//
//  SLFavoritesTableViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 14/07/2023.
//

#import <UIKit/UIKit.h>
#import "Result.h"
#import "Configuration.h"
#import <SDWebImage/SDWebImage.h>
#import "CoreDataManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLFavoritesTableViewCell : UITableViewCell
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) Result *result;
- (void)configCell;
@end

NS_ASSUME_NONNULL_END
