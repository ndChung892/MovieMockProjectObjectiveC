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
- (void)didSelectCellWithId:(NSNumber *)iD;
@end

@interface SLMoviesTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<SLMoviesTableViewViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
