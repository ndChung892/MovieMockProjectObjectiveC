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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starTapped:)];
    [self.imgFavorite addGestureRecognizer:tapGesture];
    self.imgFavorite.userInteractionEnabled = YES;
    
}

- (void)starTapped:(UITapGestureRecognizer *)gesture {
    self.isFavorite = !self.isFavorite;
    if (self.isFavorite) {
        self.imgFavorite.image = [UIImage systemImageNamed:@"star.fill"];
    } else {
        self.imgFavorite.image = [UIImage systemImageNamed:@"star"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:false animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:false animated:animated];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleMovielbl.text = @"";
    self.overviewTextView.text = @"";
    self.releaseDatelbl.text = @"";
    self.ratinglbl.text = @"";
    [self.imgMovie setImage:[UIImage imageNamed:@""]];
}

-(void)configTableViewCell:(Result *) result {
    
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
