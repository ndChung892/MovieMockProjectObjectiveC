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
@protocol SLDetailMoviesViewControllerDelegate <NSObject>

- (void)favoriteDidChange:(BOOL)isFavorite withResult:(Result *)result;

@end

@interface SLDetailMoviesViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) Result *result;
@property (nonatomic) BOOL isFavorite;

@property (nonatomic, weak) id<SLDetailMoviesViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
