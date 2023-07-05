//
//  SLMoviesCollectionViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 04/07/2023.
//

#import "SLMoviesCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "Configuration.h"
#import "Result.h"

@interface SLMoviesCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameMovieslbl;
@end

@implementation SLMoviesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgCollectionView.heightAnchor constraintEqualToAnchor:self.imgCollectionView.widthAnchor].active = YES;

}


- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imgCollectionView setImage:[UIImage imageNamed:@""]];
    [self.nameMovieslbl setText:@""];
}

-(void) configCollectionView:(Result *)result {
    [self.imgCollectionView
     sd_setImageWithURL:[NSURL URLWithString:[NSString
                                        stringWithFormat:@"%@%@", imageURL, result.imgURL]]];
    [self.nameMovieslbl setText:result.title];
}

@end
