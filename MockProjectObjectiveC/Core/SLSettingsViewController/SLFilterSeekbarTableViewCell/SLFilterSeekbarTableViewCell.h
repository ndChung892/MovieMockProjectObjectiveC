//
//  SLFilterSeekbarTableViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/07/2023.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLFilterSeekbarTableViewCellDelegate <NSObject>

- (void)sliderValueChange:(float)sliderValue;

@end

@interface SLFilterSeekbarTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SLFilterSeekbarTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
