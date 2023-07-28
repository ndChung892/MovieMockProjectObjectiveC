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
#import "CoreDataManager.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface SLMoviesTableView()

@property (nonatomic) BOOL isFavorite;
@property (nonatomic) SLMoviesViewController *moviesVC;


@end

@implementation SLMoviesTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Handle get data from api
        self.model = [[Model alloc]init];
        self.result = [[Result alloc]init];
        self.moviesVC = [[SLMoviesViewController alloc]init];
        self.resultsArr = [[NSMutableArray alloc]init];
        // Setup tableView
        [self setupTableView];
        [self addSubview:self.tableView];
        [self setupConstraints];
        self.pageNumber = 1;
        [self setupPullToRefresh];
    }
    return self;
}

- (void)reloadview {
    
    [self.resultsArr addObjectsFromArray:self.model.results];
    [self.tableView reloadData];
    [self.tableView.infiniteScrollingView stopAnimating];
}

#pragma mark - Pull to refresh
- (void)setupPullToRefresh {
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        // Call API when pull down
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // Call API when pull up
        weakSelf.pageNumber += 1;
        [weakSelf.delegate didPullToRefresh:weakSelf.pageNumber];
        
    }];
}

#pragma mark - tableView
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    // Add the UITableView to the CustomTableView
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Register UITableViewCell class if needed
    [self.tableView registerNib:[UINib
                                 nibWithNibName:@"SLMoviesTableViewCell"
                                 bundle:nil] forCellReuseIdentifier:@"cellMoviesTableView"];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // Add constraints to position and size the UITableView
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in your table
    return self.resultsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLMoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMoviesTableView" forIndexPath:indexPath];
    // Configure the cell with result
    cell.result = self.resultsArr[indexPath.row];
    [cell configTableViewCell];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get movie id and pass to viewcontroller
    [self.delegate didSelectCellWithId:self.resultsArr[indexPath.row]];
}

@end
