//
//  SLMoviesViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 21/06/2023.
//

#import "SLMoviesViewController.h"
#import "SLMoviesTableView.h"
#import "SLMoviesCollectionView.h"
#import "SLDetailMoviesViewController.h"
#import "SLFavoritesViewController.h"
#import "Configuration.h"
#import "NetworkManager.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "NotificationConstant.h"

#pragma mark - SLMoviesViewController
@interface SLMoviesViewController () <SLMoviesTableViewViewDelegate, SLMoviesCollectionViewDelegate, SLDetailMoviesViewControllerDelegate>
@property (nonatomic, strong) SLMoviesTableView *tableViewMovies;
@property (nonatomic, strong) SLMoviesCollectionView *collectionViewMovies;
@property (nonatomic, strong) UIBarButtonItem *switchButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) SLDetailMoviesViewController *detailVC;
@end

@implementation SLMoviesViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Popular Movie"];
    
    [self initView];
//    self.tableViewMovies.pageNumber = 1;
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    [self setupRightButtonNavigation];
    [self.spinner startAnimating];
    self.path = @"popular";
    [self fetchMovie:1];
    [self.tableViewMovies setDelegate:self];
    [self.collectionViewMovies setDelegate:self];
    [self addObserverNotificationCenter];
    
    
}

- (void)addObserverNotificationCenter {
    // Option Filter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSelectedFilterNotification:)
                                                 name:NOTIFICATION_SETTING_DID_SELECT_FILTER_OPTION
                                               object:nil];
    // Option Rating
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handSelectedSortNotification:)
                                                name:NOTIFICATION_SETTING_DID_SELECT_SORT_OPTION
                                              object:nil];
    
    // Option Release Date
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleSelectedReleaseDateNotification:) name: NOTIFICATION_SETTING_RELEASAE_DATE_UPDATE
                                              object:nil];
    // Option Rating Value
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSliderValueChanged:)
                                                 name:NOTIFICATION_SETTING_SEEKBAR_VALUE_UPDATE
                                               object:nil];
    
    // Application display detail of movies did remind
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleScreenNotification:)
                                                 name:NOTIFICATION_DETAIL_MOVIE_DID_REMIND
                                               object:nil];
    
    // Favorite did clear
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handeFavoriteDidChange:) name:NOTIFICATION_FAVORTIE_DID_CHANGE object:nil];
    
    //Favorite
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle:) name:@"haha" object:nil];
}

#pragma mark - Handle Notification Center
-(void)handleSliderValueChanged:(NSNotification *)notification {
    NSNumber *sliderValueNumber = notification.userInfo[@"sliderValue"];
    self.tableViewMovies.ratingValue = [sliderValueNumber floatValue];
    self.collectionViewMovies.ratingValue = [sliderValueNumber floatValue];
    [self fetchMovie:1];
}

- (void)handSelectedSortNotification:(NSNotification *)notificaiton {
    NSString *sortSelected = notificaiton.userInfo[@"selectedSortOption"];
    if ([sortSelected isEqualToString:@"Release Date"]) {
        self.tableViewMovies.sortSelected = sortSelected;
        self.collectionViewMovies.isSortByRating = NO;
    } else if ([sortSelected isEqualToString:@"Rating"]) {
        self.tableViewMovies.sortSelected = sortSelected;
        self.collectionViewMovies.isSortByRating = YES;
    }
    [self fetchMovie:1];
}

- (void)handleSelectedReleaseDateNotification:(NSNotification *)notification {
    NSDate *releaseYear = notification.userInfo[@"releaseDate"];
    self.tableViewMovies.releaseYear = releaseYear;
    self.collectionViewMovies.releaseYear = releaseYear;
    [self fetchMovie:1];
}

- (void)handleSelectedFilterNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *selectedOption = userInfo[@"selectedFilterOption"];
    self.path = selectedOption;
    [self fetchMovie:1];
}

- (void)handle:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    BOOL isFavorite = [userInfo[@"isFavorite"] boolValue];
    for(Result *result in self.tableViewMovies.resultsArr) {
        if([userInfo[@"id"] intValue] == [result.iD intValue]) {
            result.isFavorite = isFavorite;
        }
    }
    [self.tableViewMovies.tableView reloadData];
}

- (void)handleScreenNotification:(NSNotification *)notification {
    NSLog(@"noticee%@",notification.object[@"title"]);
    [self.navigationController popViewControllerAnimated:NO];
    NSDictionary *userInfo = notification.userInfo;
    Result *result = [[Result alloc]init];
    result.title = userInfo[@"title"];
    result.iD = userInfo[@"id"];
    result.overView = userInfo[@"overview"];
    result.releaseDate = userInfo[@"releaseDate"];
    result.rating = userInfo[@"rating"];
    result.imgURL = userInfo[@"imgURL"];
    self.detailVC.result = result;
    [[CoreDataManager sharedInstance] removeReminder:result.iD];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide animated:YES];
    [self.navigationController pushViewController:self.detailVC animated:YES];
}

- (void)handeFavoriteDidChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"haha %@", [self.tableViewMovies.resultsArr valueForKey:@"isFavorite"]);
    for(Result *result in self.tableViewMovies.resultsArr) {
        if([userInfo[@"id"] intValue] == [result.iD intValue]) {
            result.isFavorite = NO;
        }
    }
    [self.tableViewMovies.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.detailVC = [[SLDetailMoviesViewController alloc]initWithNibName:@"SLDetailMoviesViewController" bundle:nil];
    self.detailVC.delegate = self;
}

- (void)setupRightButtonNavigation {
    self.switchButton = [[UIBarButtonItem alloc]
                         initWithImage:[UIImage systemImageNamed:@"list.bullet"]
                         style:UIBarButtonItemStylePlain
                         target:self
                         action:@selector(switchTransition:)];
    
    self.navigationItem.rightBarButtonItem = self.switchButton;
}

- (void)fetchMovie:(int)pageNumber {
    [self.tableViewMovies.model.results removeAllObjects];
    [self.collectionViewMovies.model.results removeAllObjects];
    [[NetworkManager sharedInstance] fetchMovieAPI:pageNumber withPath:self.path withCompletion:^(NSDictionary *response) {
        NSArray *resultsArray = response[@"results"];
        if(pageNumber == 1) {
            [self.tableViewMovies.resultsArr removeAllObjects];
            [self.collectionViewMovies.resultArr removeAllObjects];
        }
        for(NSDictionary *resultDict in resultsArray) {
            (void)[self.tableViewMovies.model initMoviesData:resultDict];
            (void)[self.collectionViewMovies.model initMoviesData:resultDict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            [self.tableViewMovies setHidden:NO];
            [self.tableViewMovies reloadview];
            [self.collectionViewMovies reloadView];
        });
        
    }];
}

- (void)switchTransition:(id)sender {
    // Check state of view
    if (!self.tableViewMovies.isHidden) {
        // If current view is UITableView, transition to UICollectionView
        [self.collectionViewMovies setHidden:false];
        [self.tableViewMovies setHidden:YES];
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"square.grid.3x2.fill"];
    } else {
        // If current view is UICollectionView, transition to UITableView
        [self.collectionViewMovies setHidden:YES];
        [self.tableViewMovies setHidden:NO];
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"list.bullet"];
    }
}

- (void)initView {
    //Setup tableView
    self.tableViewMovies = [[SLMoviesTableView alloc]init];
    [self.tableViewMovies setHidden:YES];
    self.tableViewMovies.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableViewMovies];
    
    //Setup CollectionView
    self.collectionViewMovies = [[SLMoviesCollectionView alloc]init];
    [self.view addSubview:self.collectionViewMovies];
    [self.collectionViewMovies setHidden:YES];
    self.collectionViewMovies.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Setup Spinner
    self.spinner = [[UIActivityIndicatorView alloc]init] ;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    //Add constraint
    [NSLayoutConstraint activateConstraints:@[
        [self.tableViewMovies.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableViewMovies.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableViewMovies.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableViewMovies.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        
        [self.collectionViewMovies.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionViewMovies.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionViewMovies.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionViewMovies.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.spinner.widthAnchor constraintEqualToConstant:100],
        [self.spinner.heightAnchor constraintEqualToConstant:100],
        [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
}

- (void)didSelectCellWithId:(nonnull Result *)result {
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide animated:YES];
    self.detailVC.result = result;
    [self.navigationController setViewControllers:@[self, self.detailVC] animated:YES];
    
}

- (void)didPullToRefresh:(int)pageNumber {
    [self fetchMovie:pageNumber];
}

- (void)favoriteClickHandler:(BOOL)isFavorite withResult:(Result *)result {
    if(isFavorite) {
        if(![[CoreDataManager sharedInstance] interateFavorites:result.iD]){
            [[CoreDataManager sharedInstance] createFavorites:result];
            result.isFavorite = YES;
        }
    } else {
        [[CoreDataManager sharedInstance] removeFavorites:result];
        result.isFavorite = NO;
    }
}

- (void)favoriteDidChange:(BOOL)isFavorite withResult:(Result *)result {
    result.isFavorite = isFavorite;
    [self.tableViewMovies.tableView reloadData];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
