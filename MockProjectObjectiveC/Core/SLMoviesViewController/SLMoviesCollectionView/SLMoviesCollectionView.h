//
//  SLMoviesCollectionView.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLMoviesCollectionViewDelegate <NSObject>
- (void)didSelectCellWithId:(NSNumber *)iD;
- (void)didPullToRefresh:(int)pageNumber;
@end

@interface SLMoviesCollectionView : UIView <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property Model *model;
@property Result *result;
@property (nonatomic, weak) id<SLMoviesCollectionViewDelegate> delegate;
- (void)reloadView;

@property (nonatomic) NSDate *releaseYear;
@property (nonatomic) float ratingValue;
@property (nonatomic) BOOL isSortByRating;
@end

NS_ASSUME_NONNULL_END
