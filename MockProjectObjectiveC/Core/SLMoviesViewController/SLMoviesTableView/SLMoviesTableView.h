//
//  SLMoviesTableView.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>
#import "SLMoviesViewController.h"
#import "Model.h"
#import "SLDetailMoviesViewController.h"
#import "SLMoviesTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLMoviesTableViewViewDelegate <NSObject>
- (void)didSelectCellWithId:(Result *)result;
- (void)didPullToRefresh:(int) pageNumber;
- (void)favoriteClickHandler:(BOOL)isFavorite withResult:(Result *)result;
@end

@interface SLMoviesTableView : UIView <UITableViewDelegate, UITableViewDataSource, SLMoviesTableViewCellDelegate>

@property (nonatomic, weak) id<SLMoviesTableViewViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property Model *model;
@property (nonatomic, strong) NSManagedObjectContext *context;
- (void)reloadview;
@property (nonatomic) NSMutableArray<Result *> *resultsArr;
@property (nonatomic) int pageNumber;

@property (nonatomic) NSDate *releaseYear;
@property (nonatomic) float ratingValue;
@property (nonatomic) NSString *sortSelected;


@end

NS_ASSUME_NONNULL_END
