//
//  SLSettingsViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 21/06/2023.
//

#import "SLSettingsViewController.h"

#pragma mark - SLSettingViewController

@interface SLSettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *selectedOption;
@property (nonatomic) UITableView *tableView;
@end

@implementation SLSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Setting"];
    // Do any additional setup after loading the view from its nib.
    self.options = @[@"Popular Movies", @"Top Rated Movies", @"Upcomming Movies", @"NowPlaying Movies"];
    [self initView];
    
}

- (void)initView {
    UINavigationController *navigationController = self.navigationController;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"OptionCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [navigationController.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:navigationController.navigationBar.bottomAnchor constant:8],
        [self.tableView.trailingAnchor constraintEqualToAnchor:navigationController.view.trailingAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:navigationController.view.leadingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:navigationController.view.bottomAnchor],
    ]];
}


#pragma mark - TableView Delegate


#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
    cell.textLabel.text = self.options[indexPath.row];
    
    
    if ([self.options[indexPath.row] isEqualToString:self.selectedOption]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedOption = self.options[indexPath.row];
    NSDictionary *userInfo = @{@"selectedOption": self.selectedOption};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedOptionNotification" object:nil userInfo:userInfo];
//    if ([self.selectedOption isEqualToString:@"Popular Movies"]) {
//        NSLog(@"Popular Movies");
//    } else if ([self.selectedOption isEqualToString:@"Top Rated Movies"]) {
//        NSLog(@"Top Rated Movies");
//    } else if ([self.selectedOption isEqualToString:@"Upcomming Movies"]) {
//        NSLog(@"Upcomming Movies");
//    } else if ([self.selectedOption isEqualToString:@"NowPlaying Movies"]) {
//        NSLog(@"NowPlaying Movies");
//    }
    [self.tableView reloadData];
}

@end
