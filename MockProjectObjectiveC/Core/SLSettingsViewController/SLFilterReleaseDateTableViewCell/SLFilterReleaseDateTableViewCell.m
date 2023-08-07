//
//  SLFilterReleaseDateTableViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 30/07/2023.
//

#import "SLFilterReleaseDateTableViewCell.h"
@interface SLFilterReleaseDateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblReleaseYear;

@end
@implementation SLFilterReleaseDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)prepareForReuse {
    [super prepareForReuse];
    self.lblReleaseYear.text = @"";
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configCell:(NSString *) releaseYear {
    self.lblReleaseYear.text = releaseYear;
}
@end
