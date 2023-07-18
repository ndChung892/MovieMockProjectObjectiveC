//
//  SLCastAndCrewCollectionViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 06/07/2023.
//

#import "SLCastAndCrewCollectionViewCell.h"
#import "CastAndCrew.h"
#import <SDWebImage.h>
#import "Configuration.h"

@interface SLCastAndCrewCollectionViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthImage;

@end

@implementation SLCastAndCrewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.imgCastAndCrew.image = [UIImage imageNamed:@""];
}

- (void)configCastAndCrewCell:(NSString *) imageName {
    [self.imgCastAndCrew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageURL, imageName]]];
}

@end
