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

#pragma mark - SLMoviesViewController

@interface SLMoviesViewController ()
@property (nonatomic, strong) SLMoviesTableView *tableViewMovies;
@property (nonatomic, strong) SLMoviesCollectionView *collectionViewMovies;
@property (nonatomic, strong) UIBarButtonItem *switchButton;


@end

@implementation SLMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Popular Movie"];
    
    [self initView];
    [self setupRightButtonNavigation];
    
    self.tableViewMovies.delegate = self;
}

-(void)setupRightButtonNavigation {
    self.switchButton = [[UIBarButtonItem alloc]
                         initWithImage:[UIImage systemImageNamed:@"list.bullet"]
                         style:UIBarButtonItemStylePlain
                         target:self
                         action:@selector(switchTransition:)];

    self.navigationItem.rightBarButtonItem = self.switchButton;
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

-(void)initView {
    //Setup tableView
    self.tableViewMovies = [[SLMoviesTableView alloc]init];
    [self.view addSubview: self.tableViewMovies];
    self.tableViewMovies.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    //Setup CollectionView
    self.collectionViewMovies = [[SLMoviesCollectionView alloc]init];
    [self.view addSubview:self.collectionViewMovies];
    [self.collectionViewMovies setHidden:true];
    self.collectionViewMovies.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Add constraint
    [NSLayoutConstraint activateConstraints:@[
        [self.tableViewMovies.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableViewMovies.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableViewMovies.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableViewMovies.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [self.collectionViewMovies.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionViewMovies.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionViewMovies.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
        [self.collectionViewMovies.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)didSelectCellWithData:(nonnull NSString *)data {
    SLDetailMoviesViewController *detailVC = [[SLDetailMoviesViewController alloc]init];
    detailVC.titleDetail = data;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
