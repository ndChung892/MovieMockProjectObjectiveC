//
//  SLMoviesTableViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>
#import "Result.h"


NS_ASSUME_NONNULL_BEGIN

@interface SLMoviesTableViewCell : UITableViewCell 

- (void)configTableViewCell;
@property (nonatomic) BOOL isFavorite;
@property (weak, nonatomic) IBOutlet UIImageView *imgFavorite;
//- (void)starTapped;
@property (nonatomic) Result *result;
@end

NS_ASSUME_NONNULL_END
