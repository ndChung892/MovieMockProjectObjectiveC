//
//  SLMoviesCollectionView.m
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import "SLMoviesCollectionView.h"

@interface SLMoviesCollectionView()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SLMoviesCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Create the UICollectionViewFlowLayout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.minimumInteritemSpacing = 0;
//        layout.minimumLineSpacing = 0;
        
        // Create the UICollectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        // Register UICollectionViewCell class if needed
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
        
        // Add the UICollectionView to the CustomTableView
        [self addSubview:self.collectionView];
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Return the number of items in your collection
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor cyanColor]];
    // Configure the cell with your data
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Handle item selection
    NSLog(@"Selected item: %ld", (long)indexPath.item);
}

@end
