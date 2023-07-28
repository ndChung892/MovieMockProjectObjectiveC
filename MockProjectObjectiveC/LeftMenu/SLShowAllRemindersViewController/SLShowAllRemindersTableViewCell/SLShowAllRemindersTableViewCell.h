//
//  SLShowAllRemindersTableViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 27/07/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLShowAllRemindersTableViewCell : UITableViewCell
- (void)configCell:(NSString *)img
          withInfo:(NSString *)info
  withReminderTime:(NSString *)reminderTime;


@end

NS_ASSUME_NONNULL_END
