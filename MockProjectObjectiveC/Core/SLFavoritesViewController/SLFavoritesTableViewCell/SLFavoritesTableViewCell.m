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
    self.result = [[Result alloc]init];
    self.overviewTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starTapped:)];
    [self.imgFavorite addGestureRecognizer:tapGesture];
    self.imgFavorite.userInteractionEnabled = YES;
}

- (void)starTapped:(UITapGestureRecognizer *)gesture {
    if (self.isFavorite) {
        self.imgFavorite.image = [UIImage systemImageNamed:@"star"];
        [[CoreDataManager sharedInstance] removeFavorites:self.result];
    } else {
        self.imgFavorite.image = [UIImage systemImageNamed:@"star.fill"];
    }
    self.isFavorite = !self.isFavorite;
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

- (void)configCell {
    self.titlelbl.text = self.result.title;
    self.overviewTextView.text = self.result.overView;
    self.releaseDatelbl.text = [NSString stringWithFormat:@"%@%@",@"Release Date: ", self.result.releaseDate];
    self.ratinglbl.text = [NSString stringWithFormat:@"%@%@", @"Rating: ", [self.result.rating stringValue]];
    [self.imgMovies
     sd_setImageWithURL:[NSURL
                         URLWithString:[NSString
                                        stringWithFormat:@"%@%@", imageURL, self.result.imgURL]]];
    self.imgFavorite.image = self.isFavorite ? [UIImage systemImageNamed:@"star.fill"] : [UIImage systemImageNamed:@"star"];
}
@end
