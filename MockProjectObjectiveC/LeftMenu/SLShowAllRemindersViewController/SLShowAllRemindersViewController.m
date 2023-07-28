//
//  SLShowAllRemindersViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 27/07/2023.
//

#import "SLShowAllRemindersViewController.h"
#import "SLShowAllRemindersTableViewCell.h"
#import "CoreDataManager.h"
#import "Reminders+CoreDataClass.h"
#import "Reminders+CoreDataProperties.h"
#import "SLDetailMoviesViewController.h"

@interface SLShowAllRemindersViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<Reminders *> *reminderArr;
@end

@implementation SLShowAllRemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    // Add the UITableView to the CustomTableView
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.reminderArr = [[NSMutableArray alloc]init];
    [self.view setBackgroundColor: [UIColor cyanColor]];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SLShowAllRemindersTableViewCell" bundle:nil] forCellReuseIdentifier:@"reminderCell"];
    
    [NSLayoutConstraint activateConstraints:@[
        // Add constraints to position and size the UITableView
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor]
        
    ]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[CoreDataManager sharedInstance]getAllReminders:^(NSArray<Reminders *> *items) {
            self.reminderArr = [items mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLShowAllRemindersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reminderCell" forIndexPath:indexPath];
    [cell configCell:self.reminderArr[indexPath.row].imgUrl
            withInfo:[NSString
                      stringWithFormat:@"%@ - %@ - %f",
                      self.reminderArr[indexPath.row].title,
                      self.reminderArr[indexPath.row].releaseDate,
                      self.reminderArr[indexPath.row].rating]
    withReminderTime:[NSString stringWithFormat:@"%@", self.reminderArr[indexPath.row].reminderTime]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reminderArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SLDetailMoviesViewController *detailVC = [[SLDetailMoviesViewController alloc]init];
}
@end