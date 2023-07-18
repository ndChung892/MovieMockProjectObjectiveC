//
//  SLDetailMoviesViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 04/07/2023.
//

#import "SLDetailMoviesViewController.h"
#import "NetworkManager.h"
#import <SDWebImage.h>
#import "Configuration.h"
#import "CastAndCrew.h"
#import "Cast.h"
#import "Crew.h"
#import "SLCastAndCrewCollectionViewCell.h"
#import "Favorites+CoreDataClass.h"
#import "Favorites+CoreDataProperties.h"
#import "CoreDataManager.h"


@interface SLDetailMoviesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCastAndCrew;
@property (weak, nonatomic) IBOutlet UIImageView *imgMovie;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@property (weak, nonatomic) IBOutlet UILabel *ratinglbl;
@property (weak, nonatomic) IBOutlet UILabel *releaseDatelbl;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteButton;



@property (nonatomic) NSArray *castAndCrewArr;
//@property (nonatomic) NSMutableArray *castAndCrewArr;
@end

@implementation SLDetailMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDetailMovie];

    [self initCastAndCrew];
    self.castAndCrewArr = [[NSArray alloc] init];
    
    self.delegate = self;
    [self initTappedFavorite];
    
    // Setup layout for collectionView
    self.collectionViewCastAndCrew.delegate = self;
    self.collectionViewCastAndCrew.dataSource = self;
    
    [self.collectionViewCastAndCrew registerNib:[UINib nibWithNibName:@"SLCastAndCrewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"castAndCrewCell"];
    
}

#pragma mark - Tapped favorite
- (void)initTappedFavorite {
    self.isFavorite = [[CoreDataManager sharedInstance] interateItem:self.result.iD];
    if(self.isFavorite) {
        self.favoriteButton.image = [UIImage systemImageNamed:@"star.fill"];
    } else {
        self.favoriteButton.image = [UIImage systemImageNamed:@"star"];
    }
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [self.favoriteButton addGestureRecognizer:tapGestureRecognizer];
        self.favoriteButton.userInteractionEnabled = YES;
}

- (void)imageTapped:(UITapGestureRecognizer *)sender {
        if (!self.isFavorite) {
            self.favoriteButton.image = [UIImage systemImageNamed:@"star.fill"];
            [[CoreDataManager sharedInstance] createItem:self.result];
            self.isFavorite = true;
        } else {
            self.favoriteButton.image = [UIImage systemImageNamed:@"star"];
            self.isFavorite = false;
            [[CoreDataManager sharedInstance] removeItem:self.result];
        }
}

#pragma mark - Detail movie
- (void)initDetailMovie {
    self.title = self.result.title;
    [self.imgMovie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageURL, self.result.imgURL]]];
    self.overviewTextView.text = self.result.overView;
    self.ratinglbl.text = [self.result.rating stringValue];
    self.releaseDatelbl.text = self.result.releaseDate;
}

- (void)didFetchAPIResponse:(NSDictionary *) response {
//    [self.view reloadInputViews];
}

#pragma mark - Cast and Crew
- (void)initCastAndCrew {
    [[NetworkManager sharedInstance]fetchCastAndCrew:self.result.iD withCompletion:^(NSDictionary *response) {
        NSArray<Cast *> *Casts= response[@"cast"];
        NSArray<Crew *> *Crews = response[@"crew"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for(NSDictionary *castDict in Casts) {
            if (castDict[@"profile_path"]  != [NSNull null]) {
                [arr addObject: castDict[@"profile_path"]];
                }
        }
        
        for(NSDictionary *crewDict in Crews) {
            if (crewDict[@"profile_path"]  != [NSNull null]) {
                [arr addObject:crewDict[@"profile_path"]];
                }
        }
        NSSet *uniqueSet = [NSSet setWithArray:arr];
        self.castAndCrewArr = [uniqueSet allObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{;
            [self.collectionViewCastAndCrew reloadData];
        });
    }];
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLCastAndCrewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"castAndCrewCell" forIndexPath:indexPath];
    [cell configCastAndCrewCell:self.castAndCrewArr[indexPath.row]];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.castAndCrewArr.count;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDelegateFlowlayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect bounds = [UIScreen.mainScreen bounds];
    CGFloat width = (bounds.size.width-10)/4;
    return CGSizeMake(width, width);
}

@end

