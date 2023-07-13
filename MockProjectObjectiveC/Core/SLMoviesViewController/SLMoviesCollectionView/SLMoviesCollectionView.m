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


@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *resultArr;
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
        self.resultArr = [[NSMutableArray alloc]init];
        
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
- (void)setupPullToRefresh {
    __weak typeof(self) weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        // Call API when pull down
        [weakSelf.delegate didPullToRefresh:weakSelf.pageNumber];
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        // Call API when pull up
        weakSelf.pageNumber += 1;
        [weakSelf.delegate didPullToRefresh:weakSelf.pageNumber];
    }];
}

#pragma mark - spinner
- (void) setupSpinner {
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;;
}

#pragma mark - collectionView
- (void) setupCollectionView {
    // Create the UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // Create the UICollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Register UICollectionViewCell class if needed
    [self.collectionView registerNib:[UINib
                                      nibWithNibName:@"SLMoviesCollectionViewCell"
                                      bundle:nil]
          forCellWithReuseIdentifier:@"cellMoviesCollectionView"];
    
    // Add the UICollectionView to the CustomTableView
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)reloadView {
    [self.resultArr addObjectsFromArray:self.model.results];
    [self.collectionView reloadData];
    [self.collectionView.pullToRefreshView stopAnimating];
    [self.collectionView.infiniteScrollingView stopAnimating];
}

- (void)setupConstraint{
    [NSLayoutConstraint activateConstraints:@[
        // Add constraints to position and size the UICollectionView
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor ],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}


#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Return the number of items in collection
    return self.resultArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // DequeReusable and config item
    SLMoviesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellMoviesCollectionView" forIndexPath:indexPath];
    [cell configCollectionViewCell:self.resultArr[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Handle item selection
    [self.delegate didSelectCellWithId:self.resultArr[indexPath.row]];
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
