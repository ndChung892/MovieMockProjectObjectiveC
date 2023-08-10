//
//  SLMoviesTableViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>
#import "Result.h"


NS_ASSUME_NONNULL_BEGIN

@protocol SLMoviesTableViewCellDelegate <NSObject>
- (void)favoriteClickHandler:(BOOL)isFavorite withResult:(Result *)result;
@end

@interface SLMoviesTableViewCell : UITableViewCell 

- (void)configTableViewCell;
@property (nonatomic) BOOL isFavorite;
@property (weak, nonatomic) IBOutlet UIImageView *imgFavorite;
@property (nonatomic) Result *result;

@property (nonatomic, weak) id<SLMoviesTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
