//
//  SLMoviesCollectionView.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLMoviesCollectionView : UIView <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, SLMoviesDelegate>

@end

NS_ASSUME_NONNULL_END
