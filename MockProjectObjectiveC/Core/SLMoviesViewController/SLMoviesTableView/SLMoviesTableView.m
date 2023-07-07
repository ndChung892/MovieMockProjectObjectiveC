//
//  SLMoviesTableView.m
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import "SLMoviesTableView.h"
#import "SLMoviesTableViewCell.h"
#import "NetworkManager.h"
#import "Model.h"
#import "SLMoviesViewController.h"
#import "SLDetailMoviesViewController.h"
#import "Result.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface SLMoviesTableView()
@property Model *model;
@property Result *result;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) int pageNumber;
@end

@implementation SLMoviesTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Handle get data from api
        self.model = [[Model alloc]init];
        self.pageNumber = 1;
        self.backgroundColor = [UIColor systemBackgroundColor];
        
        [self fetchMovie:self.pageNumber];
        // Setup tableView
        [self setupTableView];
        [self addSubview:self.tableView];
        
        // Setup spinner
        [self setupSpinner];
        [self addSubview:self.spinner];
        [self.spinner startAnimating];
        
        [self setupConstraints];
        [self setupPullToRefresh];
        
    }
    return self;
}

#pragma mark - Pull to refresh
-(void)setupPullToRefresh {
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        // Call API when pull down
        [weakSelf fetchMovie:1];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // Call API when pull up
        weakSelf.pageNumber = weakSelf.pageNumber + 1;
        [weakSelf.spinner startAnimating];
        [weakSelf.tableView setHidden:true];
        [weakSelf.tableView setAlpha:0];
        [weakSelf fetchMovie:weakSelf.pageNumber];
    }];
}

#pragma mark - spinner
-(void) setupSpinner {
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;;
}

#pragma mark - tableView
-(void) setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    
    // Add the UITableView to the CustomTableView
    [self.tableView setHidden:true];
    [self.tableView setAlpha:0];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Register UITableViewCell class if needed
    [self.tableView registerNib:[UINib
                                 nibWithNibName:@"SLMoviesTableViewCell"
                                 bundle:nil] forCellReuseIdentifier:@"cellMoviesTableView"];
    
}

#pragma mark - Call api
-(void) fetchMovie:(int)pageNumber {
    [[NetworkManager sharedInstance] fetchMovieAPI:pageNumber withCompletion:^(NSDictionary *response) {
        self.model.page = response[@"page"];
        
        NSArray *resultsArray = response[@"results"];
        NSMutableArray *moviesArray = [[NSMutableArray alloc] init];
        for(NSDictionary *resultDict in resultsArray) {
            Result *result = [[Result alloc]init];
            result.title = resultDict[@"title"];
            result.iD = resultDict[@"id"];
            result.overView = resultDict[@"overview"];
            result.releaseDate = resultDict[@"release_date"];
            result.rating = resultDict[@"vote_average"];
            result.imgURL = resultDict[@"poster_path"];
            [moviesArray addObject:result];
        }
        self.model.results = moviesArray;
        dispatch_async(dispatch_get_main_queue(), ^{;
            [self.spinner stopAnimating];
            [self.tableView setHidden:false];
            [self.tableView reloadData];
            [UIView animateWithDuration:0.4 animations:^{
                self.tableView.alpha = 1;
            }];
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView.infiniteScrollingView stopAnimating];
        });
        
        
    }];
}

-(void) setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // Add constraints to position and size the UITableView
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        
        // Add constraints to position and size the UISpinner
        [self.spinner.widthAnchor constraintEqualToConstant:100],
        [self.spinner.heightAnchor constraintEqualToConstant:100],
        [self.spinner.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        
    ]];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in your table
    return self.model.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLMoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMoviesTableView" forIndexPath:indexPath];
    // Configure the cell with result
    self.result = self.model.results[indexPath.row];
    [cell configTableViewCell:self.result withFavorite:self.isFavorite];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get movie id and pass to viewcontroller
    self.result = self.model.results[indexPath.row];
    [self.delegate didSelectCellWithId:self.result.iD];
}


@end
