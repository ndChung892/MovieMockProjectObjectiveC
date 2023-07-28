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

NS_ASSUME_NONNULL_BEGIN

@protocol SLMoviesTableViewViewDelegate <NSObject>
- (void)didSelectCellWithId:(Result *)result;
- (void)didPullToRefresh:(int) pageNumber;
@end

@interface SLMoviesTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<SLMoviesTableViewViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property Model *model;
@property Result *result;
@property (nonatomic, strong) NSManagedObjectContext *context;
- (void)reloadview;
@property (nonatomic) NSMutableArray<Result *> *resultsArr;
@property (nonatomic) int pageNumber;
@end

NS_ASSUME_NONNULL_END
