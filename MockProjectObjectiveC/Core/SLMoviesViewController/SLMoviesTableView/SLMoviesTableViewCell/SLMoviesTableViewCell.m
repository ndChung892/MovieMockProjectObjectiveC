//
//  SLMoviesTableViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import "SLMoviesTableViewCell.h"
#import "Model.h"
#import "Configuration.h"
#import <SDWebImage/SDWebImage.h>

@interface SLMoviesTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleMovielbl;
@property (weak, nonatomic) IBOutlet UILabel *releaseDatelbl;
@property (weak, nonatomic) IBOutlet UILabel *ratinglbl;

@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imgMovie;

@end

@implementation SLMoviesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.overviewTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleMovielbl.text = @"";
    self.overviewTextView.text = @"";
    self.releaseDatelbl.text = @"";
    self.ratinglbl.text = @"";
    [self.imgMovie setImage:[UIImage imageNamed:@""]];
}

//-(void)configCell:(NSString *) title
//     withOverview:(NSString *) overView
//  withReleaseDate:(NSString *) releaseDate
//       withRating:(NSNumber *) rating
//     withImageURL:(NSString *) imgURL
//{
//    self.titleMovielbl.text = title;
//    self.overviewTextView.text = overView;
//    self.releaseDatelbl.text = [NSString stringWithFormat:@"%@%@",@"Release Date: ", releaseDate];
//    self.ratinglbl.text = [NSString stringWithFormat:@"%@%@", @"Rating: ", [rating stringValue]];
//    NSString *fullImageUrl = [NSString stringWithFormat:@"%@%@", imageURL, imgURL];
//    [self.imgMovie sd_setImageWithURL:[NSURL URLWithString:fullImageUrl]];
//
//}

-(void)configCell:(Result *) result {
    
    self.titleMovielbl.text = result.title;
    self.overviewTextView.text = result.overView;
    self.releaseDatelbl.text = [NSString stringWithFormat:@"%@%@",@"Release Date: ", result.releaseDate];
    self.ratinglbl.text = [NSString stringWithFormat:@"%@%@", @"Rating: ", [result.rating stringValue]];
    [self.imgMovie
     sd_setImageWithURL:[NSURL
                         URLWithString:[NSString
                                        stringWithFormat:@"%@%@", imageURL,result.imgURL]]];
    
}


@end
