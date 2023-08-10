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
        self.resultsArr = [[NSMutableArray alloc]init];
        [self setBackgroundColor:[UIColor systemBackgroundColor]];
        // Setup tableView
        [self setupTableView];
        [self addSubview:self.tableView];
        [self setupConstraints];
        self.pageNumber = 1;
        [self setupPullToRefresh];
        self.ratingValue = 0.0;
    }
    return self;
}

- (void)reloadview {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // Filter Array
    for (Result *result in self.model.results) {
        NSDate *releaseDate = [dateFormatter dateFromString:result.releaseDate];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *yearComponent = [calendar components:NSCalendarUnitYear fromDate:releaseDate];
        NSInteger objectYear = [yearComponent year];

        NSDateComponents *selectedDateComponent = [calendar components:NSCalendarUnitYear fromDate:self.releaseYear];
            NSInteger specifiedYear = [selectedDateComponent year];
        
        NSNumber *ratingNumber = result.rating;
        float rating = [ratingNumber floatValue];
        
        if (objectYear >= specifiedYear) {
            if (rating >= self.ratingValue) {
                [self.resultsArr addObject:result];
            }
        }
    }
    // If SelectSort
    if ([self.sortSelected isEqualToString:@"Rating"]) {
        [self.resultsArr sortUsingComparator:^NSComparisonResult(Result *result1, Result *result2) {
            NSNumber *rating1 = result1.rating;
            NSNumber *rating2 = result2.rating;
            return [rating1 compare:rating2];
        }];
    } else if ([self.sortSelected isEqualToString:@"Release Date"]) {
        [self.resultsArr sortUsingComparator:^NSComparisonResult(Result *result1, Result *result2) {
            NSDate *date1 = [dateFormatter dateFromString:result1.releaseDate];
            NSDate *date2 = [dateFormatter dateFromString:result2.releaseDate];
            return [date1 compare:date2];
        }];
    }
    [self.tableView reloadData];
    [self.tableView.infiniteScrollingView stopAnimating];
    [self.tableView.pullToRefreshView stopAnimating];
}

#pragma mark - Pull to refresh
- (void)setupPullToRefresh {
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        // Call API when pull down
        weakSelf.pageNumber = 1;
        [weakSelf.delegate didPullToRefresh:weakSelf.pageNumber];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // Call API when pull up
        weakSelf.pageNumber += 1;
        [weakSelf.delegate didPullToRefresh:weakSelf.pageNumber];
        
    }];
}

#pragma mark - tableView
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];

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
        [self.tableView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in your table
    return self.resultsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLMoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMoviesTableView" forIndexPath:indexPath];
    // Configure the cell with result
    cell.delegate = self;
    cell.result = self.resultsArr[indexPath.row];
    [cell configTableViewCell];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get movie id and pass to viewcontroller
    [self.delegate didSelectCellWithId:self.resultsArr[indexPath.row]];
}

- (void)favoriteClickHandler:(BOOL)isFavorite withResult:(Result *)result{
    [self.delegate favoriteClickHandler:isFavorite withResult:result];
}
@end
