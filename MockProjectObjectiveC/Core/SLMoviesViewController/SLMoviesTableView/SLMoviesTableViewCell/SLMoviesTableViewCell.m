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
#import "SLFavoritesViewController.h"
#import "CoreDataManager.h"
#import "Favorites+CoreDataClass.h"

@interface SLMoviesTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleMovielbl;
@property (weak, nonatomic) IBOutlet UILabel *releaseDatelbl;
@property (weak, nonatomic) IBOutlet UILabel *ratinglbl;

@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imgMovie;
@property (nonatomic) SLFavoritesViewController *favoriteVC;


@end

@implementation SLMoviesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.overviewTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starTapped:)];
    [self.imgFavorite addGestureRecognizer:tapGesture];
    self.imgFavorite.userInteractionEnabled = YES;
    self.result = [[Result alloc]init];
    
    }

- (void)starTapped:(UITapGestureRecognizer *)gesture {
    self.isFavorite = !self.isFavorite;
    if (self.isFavorite) {
        self.imgFavorite.image = [UIImage systemImageNamed:@"star.fill"];
        if(![[CoreDataManager sharedInstance] interateItem:self.result.iD]){
            [[CoreDataManager sharedInstance] createItem:self.result];
        }
    } else {
        self.imgFavorite.image = [UIImage systemImageNamed:@"star"];
        [[CoreDataManager sharedInstance] removeItem:self.result];
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
    [self.imgFavorite setImage:[UIImage imageNamed:@""]];
}

- (void)configTableViewCell {
    self.titleMovielbl.text = self.result.title;
    self.overviewTextView.text = self.result.overView;
    self.releaseDatelbl.text = [NSString stringWithFormat:@"%@%@",@"Release Date: ", self.result.releaseDate];
    self.ratinglbl.text = [NSString stringWithFormat:@"%@%@", @"Rating: ", [self.result.rating stringValue]];
    [self.imgMovie
     sd_setImageWithURL:[NSURL
                         URLWithString:[NSString
                                        stringWithFormat:@"%@%@", imageURL,self.result.imgURL]]];
    self.imgFavorite.image = self.result.isFavorite ? [UIImage systemImageNamed:@"star.fill"] : [UIImage systemImageNamed:@"star"];
}

@end
