//
//  SLMoviesViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 21/06/2023.
//

#import "SLMoviesViewController.h"
#import "SLMoviesTableView.h"
#import "SLMoviesCollectionView.h"

#pragma mark - SLMoviesViewController

@interface SLMoviesViewController ()
@property (nonatomic, strong) SLMoviesTableView *tableViewMovies;
@property (nonatomic, strong) SLMoviesCollectionView *collectionViewMovies;
@property (nonatomic, strong) UIBarButtonItem *switchButton;
@property NSArray *result;
@property BOOL isTableView;

@end

@implementation SLMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Popular Movie"];
    self.tableViewMovies = [[SLMoviesTableView alloc]init];
    self.collectionViewMovies = [[SLMoviesCollectionView alloc]init];
    [self.view addSubview: self.tableViewMovies];
    [self.view addSubview:self.collectionViewMovies];
    [self.collectionViewMovies setHidden:true];
    self.tableViewMovies.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionViewMovies.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableViewMovies.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableViewMovies.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableViewMovies.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableViewMovies.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [self.collectionViewMovies.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionViewMovies.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionViewMovies.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.collectionViewMovies.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    self.isTableView = true;
    
    self.switchButton = [[UIBarButtonItem alloc]
                         initWithImage:[UIImage systemImageNamed:@"list.bullet"]
                         style:UIBarButtonItemStylePlain
                         target:self
                         action:@selector(switchButtonTapped:)];

    self.navigationItem.rightBarButtonItem = self.switchButton;
}

- (void)switchButtonTapped:(id)sender {
    // Kiểm tra trạng thái hiện tại của view
    if (!self.tableViewMovies.isHidden) {
        // Nếu view hiện tại là UITableView, thay đổi thành UICollectionView
        [self.collectionViewMovies setHidden:false];
        [self.tableViewMovies setHidden:true];
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"square.grid.3x2.fill"];
    } else {
        // Nếu view hiện tại là UICollectionView, thay đổi thành UITableView
        [self.collectionViewMovies setHidden:true];
        [self.tableViewMovies setHidden:false];
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"list.bullet"];
    }
}

@end
