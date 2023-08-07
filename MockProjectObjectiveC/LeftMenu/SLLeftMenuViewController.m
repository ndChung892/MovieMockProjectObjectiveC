//
//  SLLeftMenuViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 26/06/2023.
//

#import "SLLeftMenuViewController.h"
#import "SLEditProfileViewController.h"
#import "SLSettingsViewController.h"
#import "SLShowAllRemindersViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>

#pragma mark - SLLeftMenuViewController
@interface SLLeftMenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SLEditProfileViewController * editVC;
@property (weak, nonatomic) IBOutlet UILabel *lblDoB;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UIView *viewReminder;


@property (nonatomic, strong) NSMutableArray <Reminders *> *reminders;
@end

@implementation SLLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2;
    self.imgProfile.layer.borderWidth = 2.0;
    self.imgProfile.layer.borderColor = [[UIColor blackColor]CGColor];
    self.imgProfile.clipsToBounds = YES;
    self.editVC = [[SLEditProfileViewController alloc]initWithNibName:@"SLEditProfileViewController" bundle:nil];
    self.editVC.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib
                                      nibWithNibName:@"SLRemindersCollectionViewCell"
                                      bundle:nil] forCellWithReuseIdentifier:@"reminderCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // lbl Name
    [self setupProfileView];
    
    [[CoreDataManager sharedInstance]getAllReminders:^(NSArray<Reminders *> *items) {
        self.reminders = [items mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
//    [[CoreDataManager sharedInstance]removeAllReminders];
    
    [[CoreDataManager sharedInstance]checkReminders:[NSDate date]];
    if ([[CoreDataManager sharedInstance] isExistReminder]) {
        self.viewReminder.hidden = NO;
    } else {
        self.viewReminder.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (void)setupProfileView {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"name"] == nil) {
        self.lblName.text = @"Nguyễn Văn A";
    } else {
        self.lblName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    }
    // lbl Email
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"email"] == nil) {
        self.lblEmail.text = @"abc@123";
    } else {
        self.lblEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    }
    // lbl DOB
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"dob"] == nil) {
        self.lblDoB.text = @"dd/MM/yyyy";
    } else {
        self.lblDoB.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
    }
    //lbl IMG
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedImage"] == nil) {
        self.imgProfile.image = [UIImage imageNamed:@"avatar"];
    } else {
        self.imgProfile.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedImage"]];
    }
    //lbl Gender
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"gender"] == nil) {
        self.lblGender.text = @"gender";
    } else {
        self.lblGender.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    }
}

- (IBAction)showAllButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"transitionToSetting" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAllBtn" object:nil];
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)editButton:(id)sender {
    [self presentViewController:self.editVC animated:YES completion:nil];
}

- (void)editProfileViewControllerDidClose:(SLEditProfileViewController *)editVC {
//    self.imgProfile.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedImage"]];
//    self.lblName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
//    self.lblEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
//    self.lblDoB.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
//    self.lblGender.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    [self setupProfileView];
    [self.view reloadInputViews];
}


#pragma mark - Reminder ColectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLRemindersCollectionViewCell *cell = [collectionView
                                           dequeueReusableCellWithReuseIdentifier:@"reminderCell"
                                           forIndexPath:indexPath];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];

    NSString *info = [NSString
                      stringWithFormat:@"%@ - %@ - %.1f",
                      self.reminders[indexPath.row].title,
                      self.reminders[indexPath.row].releaseDate,
                      self.reminders[indexPath.row].rating];
    NSString *reminderTime = [dateFormatter stringFromDate:self.reminders[indexPath.row].reminderTime];
    [cell configCell:info withReminderTime:reminderTime];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.reminders.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Config Size of item
    CGRect bounds = [UIScreen.mainScreen bounds];
    return CGSizeMake(bounds.size.width, bounds.size.width/6);
}

@end
