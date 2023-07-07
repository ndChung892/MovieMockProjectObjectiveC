//
//  SLCastAndCrewCollectionViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 06/07/2023.
//

#import <UIKit/UIKit.h>
#import "CastAndCrew.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLCastAndCrewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCastAndCrew;
//-(void) configCastAndCrewCell:(NSString *) imageName;
-(void) configCastAndCrewCell:(CastAndCrew *) castAndCrew;

@end

NS_ASSUME_NONNULL_END
