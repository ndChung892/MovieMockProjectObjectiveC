//
//  SLDetailMoviesViewController.h
//  MockProjectObjectiveC
//
//  Created by Chung on 04/07/2023.
//

#import <UIKit/UIKit.h>
#import "Result.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SLDetailMoviesViewControllerDelegate <NSObject>

- (void)didFetchAPIResponse:(NSDictionary *) response;


@end


@interface SLDetailMoviesViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SLDetailMoviesViewControllerDelegate>

@property (nonatomic, strong) Result *result;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, weak) id <SLDetailMoviesViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
