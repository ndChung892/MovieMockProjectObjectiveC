//
//  SLFavoritesTableViewCell.m
//  MockProjectObjectiveC
//
//  Created by Chung on 14/07/2023.
//

#import "SLFavoritesTableViewCell.h"

@interface SLFavoritesTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titlelbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgMovies;
@property (weak, nonatomic) IBOutlet UILabel *releaseDatelbl;
@property (weak, nonatomic) IBOutlet UILabel *ratinglbl;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imgFavorite;

@end
@implementation SLFavoritesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.overviewTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:NO animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titlelbl.text = @"";
    self.imgMovies.image = [UIImage imageNamed:@""];
    self.releaseDatelbl.text = @"";
    self.ratinglbl.text = @"";
    self.overviewTextView.text = @"";
    self.imgFavorite.image = [UIImage imageNamed:@""];
}

- (void)configCell:(Result *)result{
    self.titlelbl.text = result.title;
    self.overviewTextView.text = result.overView;
    self.releaseDatelbl.text = [NSString stringWithFormat:@"%@%@",@"Release Date: ", result.releaseDate];
    self.ratinglbl.text = [NSString stringWithFormat:@"%@%@", @"Rating: ", [result.rating stringValue]];
    [self.imgMovies
     sd_setImageWithURL:[NSURL
                         URLWithString:[NSString
                                        stringWithFormat:@"%@%@", imageURL, result.imgURL]]];
    self.imgFavorite.image = [UIImage systemImageNamed:@"star.fill"];
}
@end
