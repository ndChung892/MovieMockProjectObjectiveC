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


@property (nonatomic, strong) NSMutableArray <Reminders *> *reminders;
@end

@implementation SLLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2;
    self.imgProfile.clipsToBounds = YES;
    self.editVC = [[SLEditProfileViewController alloc]initWithNibName:@"SLEditProfileViewController" bundle:nil];
    self.editVC.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SLRemindersCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"reminderCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.lblName.text = @" ";
    self.lblName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    
    self.lblEmail.text = @" ";
    self.lblEmail.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    
    self.lblDoB.text = @" ";
    self.lblDoB.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"dob"];
    
    self.imgProfile.image = [UIImage imageNamed:@""];
    self.imgProfile.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedImage"]];
    self.lblGender.text = @" ";
    self.lblGender.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    
    [[CoreDataManager sharedInstance]getAllReminders:^(NSArray<Reminders *> *items) {
        self.reminders = [items mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
//    [[CoreDataManager sharedInstance]removeAllReminders];
    
    [[CoreDataManager sharedInstance]checkReminders: [NSDate date]];
    [self.collectionView reloadData];
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
    self.imgProfile.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedImage"]];
    self.lblName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    self.lblEmail.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    self.lblDoB.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"dob"];
    self.lblGender.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"gender"];
    [self.view reloadInputViews];
}


#pragma mark - Reminder ColectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLRemindersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reminderCell" forIndexPath:indexPath];
    NSString *info = [NSString
                      stringWithFormat:@"%@ - %@ - %f",
                      self.reminders[indexPath.row].title,
                      self.reminders[indexPath.row].releaseDate,
                      self.reminders[indexPath.row].rating];
    NSString *reminderTime = [NSString stringWithFormat:@"%@", self.reminders[indexPath.row].reminderTime];
    [cell configCell:info withReminderTime:reminderTime];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.reminders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Config Size of item
    CGRect bounds = [UIScreen.mainScreen bounds];
    return CGSizeMake(bounds.size.width, bounds.size.width/6);
}

@end
