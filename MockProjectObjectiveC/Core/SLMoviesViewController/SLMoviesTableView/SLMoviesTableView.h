//
//  SLMoviesTableView.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>
#import "SLMoviesViewController.h"
#import "Model.h"


NS_ASSUME_NONNULL_BEGIN

@protocol SLMoviesTableViewViewDelegate <NSObject>
- (void)didSelectCellWithData:(NSString *)data;
@end

@interface SLMoviesTableView : UIView <UITableViewDelegate, UITableViewDataSource, SLMoviesDelegate>

@property (nonatomic, weak) id<SLMoviesTableViewViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
