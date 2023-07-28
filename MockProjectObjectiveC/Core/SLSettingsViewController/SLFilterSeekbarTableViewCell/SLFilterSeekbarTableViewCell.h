//
//  SLFilterSeekbarTableViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/07/2023.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLFilterSeekbarTableViewCell : UITableViewCell

- (void)configureCellWithFilterOption:(Filter *)filterOption;

@end

NS_ASSUME_NONNULL_END
