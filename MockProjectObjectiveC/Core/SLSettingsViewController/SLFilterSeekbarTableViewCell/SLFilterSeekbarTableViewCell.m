//
//  SLFilterSeekbarTableViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 28/07/2023.
//

#import "SLFilterSeekbarTableViewCell.h"
@interface SLFilterSeekbarTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISlider *seekBar;

@end

@implementation SLFilterSeekbarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.seekBar.minimumValue = 0.0;
    self.seekBar.maximumValue = 10.0;
    self.seekBar.value = 5.0;
    [self.seekBar addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.valueLabel.text = @"5.0";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)sliderValueChanged:(UISlider *)sender {
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f", sender.value];
    NSNumber *sliderValueNumber = @(sender.value);
    NSDictionary *userInfo = @{@"sliderValue": sliderValueNumber};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingCellSeekBarValueNotification" object:nil userInfo:userInfo];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

@end
