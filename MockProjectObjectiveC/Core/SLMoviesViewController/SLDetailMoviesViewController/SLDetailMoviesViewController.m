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
-(void) initTappedFavorite {
    self.isFavorite = false;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [self.favoriteButton addGestureRecognizer:tapGestureRecognizer];
        self.favoriteButton.userInteractionEnabled = YES;
}

- (void)imageTapped:(UITapGestureRecognizer *)sender {
        if (!self.isFavorite) {
            self.favoriteButton.image = [UIImage systemImageNamed:@"star.fill"];
            self.isFavorite = true;
        } else {
            self.favoriteButton.image = [UIImage systemImageNamed:@"star"];
            self.isFavorite = false;
        }
}

#pragma mark - Detail movie
- (void) initDetailMovie {
        [[NetworkManager sharedInstance] fetchDetailMovieAPI:self.idMovie withCompletion:^(NSDictionary *response) {
            self.title = response[@"original_title"];
            [self.imgMovie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageURL, response[@"poster_path"]]]];
            self.overviewTextView.text = response[@"overview"];
            self.releaseDatelbl.text = response[@"release_date"];
            self.ratinglbl.text = [NSString stringWithFormat:@"%.1f%@",[response[@"vote_average"] floatValue],@"/10"];
            
            SLCastAndCrewCollectionViewCell *cell = [[SLCastAndCrewCollectionViewCell alloc]init];
            [cell.imgCastAndCrew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageURL, response[@"poster_path"]]]];
        }];
}



- (void)didFetchAPIResponse:(NSDictionary *) response {
//    [self.view reloadInputViews];
}

#pragma mark - Cast and Crew
- (void) initCastAndCrew {
    [[NetworkManager sharedInstance]fetchCastAndCrew:self.idMovie withCompletion:^(NSDictionary *response) {
        
        NSArray<Cast *> *Casts= response[@"cast"];
        NSArray<Crew *> *Crews = response[@"crew"];
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for(NSDictionary *castDict in Casts) {
            if (castDict[@"profile_path"]  != [NSNull null]) {
                [arr addObject
                 :castDict[@"profile_path"]];
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
//    NSArray *dataCastAndCrew = self.castAndCrewArr[indexPath.row];
//    if(dataCastAndCrew == nil) {
//
//    }
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

