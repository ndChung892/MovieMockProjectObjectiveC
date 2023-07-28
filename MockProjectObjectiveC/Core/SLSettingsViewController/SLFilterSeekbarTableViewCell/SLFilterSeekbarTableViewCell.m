//
//  SLFilterSeekbarTableViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 28/07/2023.
//

#import "SLFilterSeekbarTableViewCell.h"

@implementation SLFilterSeekbarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithFilterOption:(Filter *)filterOption {
    self.textLabel.text = filterOption.title;
    
    if (filterOption.isSeekbarOption) {
        // Nếu là cell chứa seekbar thì hiển thị seekbar và giá trị
        UISlider *seekbar = [[UISlider alloc] initWithFrame:CGRectMake(120, 10, 150, 20)];
        [seekbar addTarget:self action:@selector(seekbarValueChanged:) forControlEvents:UIControlEventValueChanged];
        seekbar.value = filterOption.seekbarValue;
        [self.contentView addSubview:seekbar];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 10, 50, 20)];
        valueLabel.text = filterOption.seekbarValueString;
        [self.contentView addSubview:valueLabel];
    } else {
        // Nếu là cell thông thường thì hiển thị dấu tích nếu đã chọn
        self.accessoryType = filterOption.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}

- (void)seekbarValueChanged:(UISlider *)sender {
    // Xử lý giá trị của seekbar khi thay đổi
    // (thay đổi giá trị của FilterOption và cập nhật seekbarValueString)
}


@end
