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
#import "Configuration.h"
#import "NetworkManager.h"
#import <SWRevealViewController/SWRevealViewController.h>

#pragma mark - SLMoviesViewController
@interface SLMoviesViewController () <SLMoviesTableViewViewDelegate, SLMoviesCollectionViewDelegate>
@property (nonatomic, strong) SLMoviesTableView *tableViewMovies;
@property (nonatomic, strong) SLMoviesCollectionView *collectionViewMovies;
@property (nonatomic, strong) UIBarButtonItem *switchButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, copy) NSString *path;
@end

@implementation SLMoviesViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Popular Movie"];
    
    [self initView];
    [self fetchMovie:1];
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    [self setupRightButtonNavigation];
    [self.spinner startAnimating];
    self.path = @"popular";
    [self.tableViewMovies setDelegate:self];
    [self.collectionViewMovies setDelegate:self];
    [self addObserverNotificationCenter];
}

- (void)addObserverNotificationCenter {
    // Option Filter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSelectedFilterNotification:) name:@"SettingDidSelectFilterOption" object:nil];
    // Option Rating
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handSelectedSortNotification:)name:@"SettingDidSelectSortOptionNotification" object:nil];
    
    // Option Release Date
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleSelectedReleaseDateNotification:) name: @"SettingDidSelectReleaseDateFilter" object:nil];
    // Option Rating Value
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSliderValueChanged:) name:@"SettingCellSeekBarValueNotification" object:nil];
}

#pragma mark - Handle Notification Center
-(void)handleSliderValueChanged:(NSNotification *)notification {
    NSNumber *sliderValueNumber = notification.userInfo[@"sliderValue"];
    NSLog(@"sliderValue ib Movie ViewController: %.1f", [sliderValueNumber floatValue]);
    self.tableViewMovies.ratingValue = [sliderValueNumber floatValue];
    self.collectionViewMovies.ratingValue = [sliderValueNumber floatValue];
}

- (void)handSelectedSortNotification:(NSNotification *)notificaiton {
    NSString *sortSelected = notificaiton.userInfo[@"SelectedSortOption"];
    if ([sortSelected isEqualToString:@"Release Date"]) {
        self.tableViewMovies.sortSelected = sortSelected;
        self.collectionViewMovies.isSortByRating = NO;
    } else if ([sortSelected isEqualToString:@"Rating"]) {
        self.tableViewMovies.sortSelected = sortSelected;
        self.collectionViewMovies.isSortByRating = YES;
    }
}

- (void)handleSelectedReleaseDateNotification:(NSNotification *)notification {
    NSDate *releaseYear = notification.userInfo[@"releaseDate"];
    self.tableViewMovies.releaseYear = releaseYear;
    self.collectionViewMovies.releaseYear = releaseYear;
}

- (void)handleSelectedFilterNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *selectedOption = userInfo[@"optionValue"];
    self.path = selectedOption;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    self.tableViewMovies.pageNumber = 1;
//    [self fetchMovie:1];
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
    SLDetailMoviesViewController *detailVC = [[SLDetailMoviesViewController alloc]initWithNibName:@"SLDetailMoviesViewController" bundle:nil];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide animated:YES];
    detailVC.result = result;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)didPullToRefresh:(int)pageNumber {
    [self fetchMovie:pageNumber];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
