//
//  SLMoviesTableViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLMoviesTableViewCell : UITableViewCell

-(void)configCell:(NSString *) title
     withOverview:(NSString *) overView
  withReleaseDate:(NSString *) releaseDate
       withRating:(NSString *) rating
     withImageURL:(NSString *) imgURL;
@end

NS_ASSUME_NONNULL_END
