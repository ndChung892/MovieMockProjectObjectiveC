//
//  SLShowAllRemindersTableViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 27/07/2023.
//

#import "SLShowAllRemindersTableViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "Configuration.h"
@interface SLShowAllRemindersTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgCell;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblReminderTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgTransition;

@end

@implementation SLShowAllRemindersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imgCell.image = [UIImage imageNamed:@""];
    self.lblInfo.text = @"";
    self.lblReminderTime.text = @"";
}

- (void)configCell:(NSString *)img
          withInfo:(NSString *)info
  withReminderTime:(NSString *)reminderTime {
    [self.imgCell sd_setImageWithURL:[NSURL URLWithString:[NSString
                                   stringWithFormat:@"%@%@", imageURL,img]]];
    self.lblInfo.text = info;
    self.lblReminderTime.text = reminderTime;
    
}

@end
