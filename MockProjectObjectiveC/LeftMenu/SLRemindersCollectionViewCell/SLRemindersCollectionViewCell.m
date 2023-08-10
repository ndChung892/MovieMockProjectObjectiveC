//
//  SLRemindersCollectionViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 26/07/2023.
//

#import "SLRemindersCollectionViewCell.h"

@interface SLRemindersCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblInfoMovie;
@property (weak, nonatomic) IBOutlet UILabel *lblReminderTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCell;

@end

@implementation SLRemindersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:[UIColor cyanColor]];
    CGRect bounds = [UIScreen.mainScreen bounds];
    self.leadingCell.constant = bounds.size.width/6;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.lblInfoMovie.text = @"";
    self.lblReminderTime.text = @"";
}

- (void)configCell:(NSString *)info withReminderTime:(NSString *) reminderTime {
    self.lblInfoMovie.text = info;
    self.lblReminderTime.text = reminderTime;
}


@end
