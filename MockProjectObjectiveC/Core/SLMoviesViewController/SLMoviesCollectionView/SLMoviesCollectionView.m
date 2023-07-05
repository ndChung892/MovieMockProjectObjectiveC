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


@interface SLMoviesCollectionView()

@property Model *model;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SLMoviesCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.model = [[Model alloc]init];
        self.model.delegate = self;
        [self.model handleData];
        [self setupSpinner];
        
        [self.spinner startAnimating];
        [self setupCollectionView];
        [self addSubview:self.spinner];
        [self addSubview:self.collectionView];
        [self setupConstraint];
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
#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Return the number of items in your collection
    return self.model.results.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLMoviesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellMoviesCollectionView" forIndexPath:indexPath];
    
//    [cell configCollectionView:[self.model.results[indexPath.row] valueForKey:@"title"]
//                    withImgURL:[self.model.results[indexPath.row] valueForKey:@"poster_path"]];
    Result *result = self.model.results[indexPath.row];
    
    [cell configCollectionView:result];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Handle item selection
    NSLog(@"Selected item: %ld", (long)indexPath.item);
}

#pragma mark - UICollectionViewDelegateFLowLayout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect bounds = [UIScreen.mainScreen bounds];
    CGFloat width = (bounds.size.width - 30)/2;
    return CGSizeMake(width, width*1.5);
}

#pragma mark - SLMoviesDelegate
-(void) didLoadInitialMovies {
    [self.spinner stopAnimating];
    [self.collectionView setHidden:false];
    [self.collectionView reloadData];
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionView.alpha = 1;
    }];
    
}
@end
