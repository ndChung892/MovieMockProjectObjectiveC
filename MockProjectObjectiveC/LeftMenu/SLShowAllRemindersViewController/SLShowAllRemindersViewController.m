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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightPickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (nonatomic, strong) NSMutableArray<Reminders *> *reminderArr;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *doneBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) SLDetailMoviesViewController *detailVC;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation SLShowAllRemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.reminderArr = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib
                                 nibWithNibName:@"SLShowAllRemindersTableViewCell"
                                 bundle:nil] forCellReuseIdentifier:@"reminderCell"];

    self.detailVC = [[SLDetailMoviesViewController alloc] init];
    [self setupPickerView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[CoreDataManager sharedInstance] getAllReminders:^(NSArray<Reminders *> *items) {
            self.reminderArr = [items mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
- (IBAction)doneBtn:(id)sender {
    self.heightPickerView.constant = 0;
    NSInteger intValueFromCoreData = self.reminderArr[self.selectedIndexPath.row].iD;
    [self datePickerValueChanged:self.datePicker.date];
    [[CoreDataManager sharedInstance] updateReminderDate:[NSNumber numberWithInteger:intValueFromCoreData] withDate:self.datePicker.date];
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)datePickerValueChanged:(NSDate *)date {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            NSInteger intValueFromCoreData = self.reminderArr[self.selectedIndexPath.row].iD;
            NSDate *dateFromCoreDate = [[CoreDataManager sharedInstance] getReminderDate:[NSNumber numberWithInteger:intValueFromCoreData]];
            // Date format
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            NSString *dateformated = [dateFormatter stringFromDate:dateFromCoreDate];
            NSString *requestIdentifier = [NSString stringWithFormat:@"movieReminder - %lld", self.reminderArr[self.selectedIndexPath.row].iD];
            NSLog(@"requestIdentifier in showall: %@", requestIdentifier);
            if ([request.identifier isEqualToString:requestIdentifier]) {
                
                UNMutableNotificationContent *content = [request.content mutableCopy];
                content.title = @"Your New Title";
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:[date timeIntervalSinceNow] repeats:NO];
                
                UNNotificationRequest *newRequest = [UNNotificationRequest requestWithIdentifier:request.identifier content:content trigger:trigger];
                
                [center removePendingNotificationRequestsWithIdentifiers:@[request.identifier]];
                [center addNotificationRequest:newRequest withCompletionHandler:nil];
                
                break;
            }
        }
    }];
}

- (IBAction)cancelBtn:(id)sender {
    self.heightPickerView.constant = 0;
}

- (void)setupPickerView {
    self.heightPickerView.constant = 0;
    [self.datePicker setDatePickerMode: UIDatePickerModeDateAndTime];
    [self.datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    NSTimeInterval oneYearTime = 365 * 24 * 60 * 60;
    NSDate *todayDate = [[NSDate date]dateByAddingTimeInterval:60];
    
    NSDate *oneYearFromToday = [todayDate
                                dateByAddingTimeInterval:oneYearTime];
    
    self.datePicker.minimumDate = todayDate;
    self.datePicker.maximumDate = oneYearFromToday;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLShowAllRemindersTableViewCell *cell = [tableView
                                             dequeueReusableCellWithIdentifier:@"reminderCell"
                                             forIndexPath:indexPath];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    [cell configCell:self.reminderArr[indexPath.row].imgUrl
            withInfo:[NSString
                      stringWithFormat:@"%@ - %@ - %.1f",
                      self.reminderArr[indexPath.row].title,
                      self.reminderArr[indexPath.row].releaseDate,
                      self.reminderArr[indexPath.row].rating]
    withReminderTime:[dateFormatter stringFromDate:self.reminderArr[indexPath.row].reminderTime]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.reminderArr.count;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    NSInteger intValueFromCoreData = self.reminderArr[indexPath.row].iD;
    self.datePicker.date = [[CoreDataManager sharedInstance] getReminderDate:[NSNumber numberWithInteger:intValueFromCoreData]];
    self.heightPickerView.constant = 260;
}

@end
