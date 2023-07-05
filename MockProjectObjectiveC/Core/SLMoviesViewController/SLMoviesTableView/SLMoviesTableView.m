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

@interface SLMoviesTableView()
@property Model *model;
//@property Result *result;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SLMoviesTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Handle get data from api
        self.model = [[Model alloc]init];
        
        self.model.delegate = self;
        [self.model handleData];
        
        // Setup tableView
        [self setupTableView];
        [self addSubview:self.tableView];
        
        // Setup spinner
        [self setupSpinner];
        [self addSubview:self.spinner];
        [self.spinner startAnimating];
        
        [self setupConstraints];
    }
    return self;
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

-(void) setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // Add constraints to position and size the UITableView
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor ],
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
    
    // Configure the cell with your data
//    [cell configCell:[self.model.results[indexPath.row] valueForKey:@"title"]
//        withOverview:[self.model.results[indexPath.row] valueForKey:@"overview"]
//     withReleaseDate:[self.model.results[indexPath.row] valueForKey:@"release_date"]
//          withRating:[self.model.results[indexPath.row] valueForKey:@"vote_average"]
//        withImageURL:[self.model.results[indexPath.row] valueForKey:@"poster_path"]
//    ];
//    Result *result = self.model.results[indexPath.row];
    Result *result = self.model.results[indexPath.row];
    [cell configCell:result];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.model.results[indexPath.row] valueForKey:@"title"];
    [self.delegate didSelectCellWithData:title];
}

#pragma mark - SLMoviesDelegate
-(void) didLoadInitialMovies {
    [self.spinner stopAnimating];
    [self.tableView setHidden:false];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.alpha = 1;
    }];
    
}

@end
