//
//  SLRemindersCollectionViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 26/07/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRemindersCollectionViewCell : UICollectionViewCell
- (void)configCell:(NSString *)info withReminderTime:(NSString *) reminderTime;
@end

NS_ASSUME_NONNULL_END
