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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


@end

@implementation SLMoviesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGRect bounds = [UIScreen.mainScreen bounds];
    CGFloat width = (bounds.size.width)/2;
    
    self.imageHeight.constant = width;
    [self.nameMovieslbl sizeToFit];
    

}


- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imgCollectionView setImage:[UIImage imageNamed:@""]];
    [self.nameMovieslbl setText:@""];
}
#pragma mark - Config cell
- (void)configCollectionViewCell:(Result *)result {
    [self.imgCollectionView
     sd_setImageWithURL:[NSURL URLWithString:[NSString
                                        stringWithFormat:@"%@%@", imageURL, result.imgURL]]];
    [self.nameMovieslbl setText:result.title];
}

@end
