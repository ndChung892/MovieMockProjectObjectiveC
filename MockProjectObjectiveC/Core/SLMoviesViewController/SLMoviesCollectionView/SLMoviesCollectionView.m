//
//  SLMoviesCollectionView.m
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import "SLMoviesCollectionView.h"
#import "SLMoviesCollectionViewCell.h"
#import "Model.h"
#import "Result.h"
#import "NetworkManager.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <SVPullToRefresh/SVPullToRefresh.h>


@interface SLMoviesCollectionView()

@property Model *model;
@property Result *result;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) int pageNumber;
@end

@implementation SLMoviesCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.model = [[Model alloc]init];
        self.result = [[Result alloc]init];
        self.backgroundColor = [UIColor systemBackgroundColor];
        self.pageNumber = 1;
        
        [self fetchMovie:self.pageNumber];
       
        // Setup Spinner
        [self setupSpinner];
        [self.spinner startAnimating];
        [self addSubview:self.spinner];
        
        // Setup CollectionView
        [self setupCollectionView];
        [self addSubview:self.collectionView];
        [self setupConstraint];
        
        [self setupPullToRefresh];
        
    }
    return self;
}

#pragma mark - Pull to refresh
-(void)setupPullToRefresh {
    __weak typeof(self) weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        // Call API when pull down
        [weakSelf fetchMovie:1];
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        // Call API when pull up
        weakSelf.pageNumber = weakSelf.pageNumber + 1;
        [weakSelf.spinner startAnimating];
        [weakSelf.collectionView setHidden:true];
        [weakSelf.collectionView setAlpha:0];
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

#pragma mark - collectionView
-(void) setupCollectionView {
    // Create the UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // Create the UICollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setHidden:true];
    [self.collectionView setAlpha:0];
    
    // Register UICollectionViewCell class if needed
    [self.collectionView registerNib:[UINib
                                      nibWithNibName:@"SLMoviesCollectionViewCell"
                                      bundle:nil]
          forCellWithReuseIdentifier:@"cellMoviesCollectionView"];
    
    // Add the UICollectionView to the CustomTableView
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)setupConstraint{
    [NSLayoutConstraint activateConstraints:@[
        // Add constraints to position and size the UICollectionView
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor ],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        // Add constraints to position and size the spinner
        [self.spinner.widthAnchor constraintEqualToConstant:100],
        [self.spinner.heightAnchor constraintEqualToConstant:100],
        [self.spinner.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
    ]];
}

#pragma mark - Call api
-(void) fetchMovie:(int)pageNumber {
    [[NetworkManager sharedInstance] fetchMovieAPI:pageNumber
                                    withCompletion:^(NSDictionary *response) {
        NSArray *resultsArray = response[@"results"];
        NSMutableArray *moviesArray = [[NSMutableArray alloc] init];
        for(NSDictionary *resultDict in resultsArray) {
            Result *result = [[Result alloc]init];
            result.title = resultDict[@"title"];
            result.iD = resultDict[@"id"];
            result.imgURL = resultDict[@"poster_path"];
            [moviesArray addObject:result];
        }
        self.model.results = moviesArray;
        dispatch_async(dispatch_get_main_queue(), ^{;
            [self.spinner stopAnimating];
            [self.collectionView setHidden:false];
            [self.collectionView reloadData];
            [UIView animateWithDuration:0.4 animations:^{
                self.collectionView.alpha = 1;
            }];
            [self.collectionView.pullToRefreshView stopAnimating];
            [self.collectionView.infiniteScrollingView stopAnimating];
        });
    }];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Return the number of items in collection
    return self.model.results.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // DequeReusable and config item
    SLMoviesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellMoviesCollectionView" forIndexPath:indexPath];
    Result *result = self.model.results[indexPath.row];
    [cell configCollectionViewCell:result];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Handle item selection
    NSLog(@"Selected item: %ld", (long)indexPath.item);
    self.result = self.model.results[indexPath.row];
    [self.delegate didSelectCellWithId:self.result.iD];
}

#pragma mark - UICollectionViewDelegateFLowLayout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Config Size of item
    CGRect bounds = [UIScreen.mainScreen bounds];
    CGFloat width = (bounds.size.width-10)/2;
    return CGSizeMake(width, width * 1.25);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

@end
