//
//  SLDetailMoviesViewController.h
//  MockProjectObjectiveC
//
//  Created by Chung on 04/07/2023.
//

#import <UIKit/UIKit.h>
#import "Result.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface SLDetailMoviesViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) Result *result;
@property (nonatomic) BOOL isFavorite;
@end

NS_ASSUME_NONNULL_END
