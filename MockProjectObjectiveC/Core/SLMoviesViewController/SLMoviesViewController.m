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

#pragma mark - SLMoviesViewController
@interface SLMoviesViewController () <SLMoviesTableViewViewDelegate, SLMoviesCollectionViewDelegate>
@property (nonatomic, strong) SLMoviesTableView *tableViewMovies;
@property (nonatomic, strong) SLMoviesCollectionView *collectionViewMovies;
@property (nonatomic, strong) UIBarButtonItem *switchButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSString *path;

@end

@implementation SLMoviesViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Popular Movie"];
    
    [self initView];
    [self fetchMovie:1];
    
    [self setupRightButtonNavigation];
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    [self.spinner startAnimating];
    self.path = @"popular";
    [self.tableViewMovies setDelegate:self];
    [self.collectionViewMovies setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSelectedOptionNotification:) name:@"SelectedOptionNotification" object:nil];
    
}

- (void)handleSelectedOptionNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *selectedOption = userInfo[@"selectedOption"];
    
    // Xử lý dữ liệu theo nhu cầu của bạn
    if ([selectedOption isEqualToString:@"Popular Movies"]) {
        self.path = @"popular";
    } else if ([selectedOption isEqualToString:@"Top Rated Movies"]) {
        self.path = @"top_rated";
    } else if ([selectedOption isEqualToString:@"Upcomming Movies"]) {
        self.path = @"upcoming";
    } else if ([selectedOption isEqualToString:@"NowPlaying Movies"]) {
        self.path = @"now_playing";
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self fetchMovie:1];
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
        for(NSDictionary *resultDict in resultsArray) {
            (void)[self.tableViewMovies.model initMoviesData:resultDict];
            (void)[self.collectionViewMovies.model initMoviesData:resultDict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{;
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
        [self.tableViewMovies setHidden:true];
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"square.grid.3x2.fill"];
    } else {
        // If current view is UICollectionView, transition to UITableView
        [self.collectionViewMovies setHidden:true];
        [self.tableViewMovies setHidden:false];
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"list.bullet"];
    }
}

- (void)initView {
    UINavigationController *navigationController = self.navigationController;
    //Setup tableView
    self.tableViewMovies = [[SLMoviesTableView alloc]init];
//    [self.view addSubview: self.tableViewMovies];
    [self.tableViewMovies setHidden:YES];
    self.tableViewMovies.translatesAutoresizingMaskIntoConstraints = NO;
    [navigationController.view addSubview:self.tableViewMovies];
    
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
        [self.tableViewMovies.topAnchor constraintEqualToAnchor:navigationController.navigationBar.bottomAnchor constant:8],
        [self.tableViewMovies.leadingAnchor constraintEqualToAnchor:navigationController.view.leadingAnchor constant:0],
        [self.tableViewMovies.trailingAnchor constraintEqualToAnchor:navigationController.view.trailingAnchor constant:0],
        [self.tableViewMovies.bottomAnchor constraintEqualToAnchor:navigationController.view.bottomAnchor],
        
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
    SLDetailMoviesViewController *detailVC = [[SLDetailMoviesViewController alloc]init];
    detailVC.result = result;
    [self.navigationController setViewControllers:@[detailVC]];
}

- (void)didPullToRefresh:(int)pageNumber {
    [self fetchMovie:pageNumber];
}

- (void)dealloc {
    // Unsubscribe when view controller is canceled
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
