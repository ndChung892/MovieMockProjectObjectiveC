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

//-(void)configCell:(NSString *) title
//     withOverview:(NSString *) overView
//  withReleaseDate:(NSString *) releaseDate
//       withRating:(NSString *) rating
//     withImageURL:(NSString *) imgURL;

-(void)configCell:(Result *) result;
@end

NS_ASSUME_NONNULL_END
