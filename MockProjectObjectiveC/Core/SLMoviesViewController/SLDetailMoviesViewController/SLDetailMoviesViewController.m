//
//  SLDetailMoviesViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 04/07/2023.
//

#import "SLDetailMoviesViewController.h"
#import "NetworkManager.h"
#import <SDWebImage.h>
#import "Configuration.h"
#import "CastAndCrew.h"
#import "Cast.h"
#import "Crew.h"
#import "SLCastAndCrewCollectionViewCell.h"
#import "Favorites+CoreDataClass.h"
#import "Favorites+CoreDataProperties.h"
#import "CoreDataManager.h"

@interface SLDetailMoviesViewController () 
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCastAndCrew;
@property (weak, nonatomic) IBOutlet UIImageView *imgMovie;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@property (weak, nonatomic) IBOutlet UILabel *ratinglbl;
@property (weak, nonatomic) IBOutlet UILabel *releaseDatelbl;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteButton;

@property (weak, nonatomic) IBOutlet UIStackView *stackViewPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *lblReminder;
@property (weak, nonatomic) IBOutlet UIButton *reminderButton;

@property (nonatomic) NSArray *castAndCrewArr;
@end

@implementation SLDetailMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDetailMovie];
    [self initCastAndCrew];
    self.castAndCrewArr = [[NSArray alloc] init];
    
    [self setupPickerView];
    [self initTappedFavorite];
    self.lblReminder.hidden = YES;
    
    // Setup layout for collectionView
    self.collectionViewCastAndCrew.delegate = self;
    self.collectionViewCastAndCrew.dataSource = self;
    
    // Notification center
    [self.collectionViewCastAndCrew registerNib:[UINib nibWithNibName:@"SLCastAndCrewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"castAndCrewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDate *currentDate = [NSDate date];
    NSLog(@"currentDate: %@", currentDate);
    [[CoreDataManager sharedInstance]checkReminders:currentDate];
    if ([[CoreDataManager sharedInstance] interateReminders:self.result.iD]){
        self.reminderButton.enabled = NO;
        self.lblReminder.hidden = NO;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];

        self.lblReminder.text =[dateFormatter stringFromDate:[[CoreDataManager sharedInstance] getReminderDate:self.result.iD]];
    }
}

- (void)setupPickerView {
    self.stackViewPickerView.hidden = YES;
    self.stackViewPickerView.backgroundColor = [UIColor whiteColor];
    [self.datePicker setDatePickerMode: UIDatePickerModeDateAndTime];
    [self.datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
}

- (IBAction)reminderButton:(id)sender {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                // Notification permission is accepted
                NSTimeInterval oneYearTime = 365 * 24 * 60 * 60;
                NSDate *todayDate = [[NSDate date]dateByAddingTimeInterval:60];
                
                NSDate *oneYearFromToday = [todayDate
                                            dateByAddingTimeInterval:oneYearTime];
                
                self.datePicker.minimumDate = todayDate;
                self.datePicker.maximumDate = oneYearFromToday;
                self.stackViewPickerView.hidden = NO;
            } else {
                // Notification access is not defined
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Permission Required" message:@"Please enable notifications for this app in Settings -> Notifications." preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        });
    }];
}

- (IBAction)saveReminder:(id)sender {
    NSDate *selectedDate = self.datePicker.date;
    self.stackViewPickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.lblReminder.text = [dateFormatter stringFromDate:self.datePicker.date];
    self.lblReminder.hidden = NO;
    [[CoreDataManager sharedInstance]createReminder:self.result withReminderTime:selectedDate];
    [self scheduleLocalNotificationAtDate:selectedDate];
    self.reminderButton.enabled = NO;
}


- (void)scheduleLocalNotificationAtDate:(NSDate *)date {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = self.result.title;
    content.body = @"It's time to watch the movies";
    content.sound = [UNNotificationSound defaultSound];
    content.categoryIdentifier = @"detailCategory";
    
    NSDateComponents *triggerDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                                                              fromDate:date];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDateComponents repeats:NO];
    
    NSString *requestIdentifier = [NSString stringWithFormat:@"movieReminder-%f", [date timeIntervalSince1970]];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Notification scheduled");
        }
    }];
}

- (IBAction)cancelReminder:(id)sender {
    self.stackViewPickerView.hidden = YES;
    self.reminderButton.enabled = YES;
    [self.view reloadInputViews];
}

#pragma mark - Tapped favorite
- (void)initTappedFavorite {
    self.isFavorite = [[CoreDataManager sharedInstance] interateFavorites:self.result.iD];
    if(self.isFavorite) {
        self.favoriteButton.image = [UIImage systemImageNamed:@"star.fill"];
    } else {
        self.favoriteButton.image = [UIImage systemImageNamed:@"star"];
    }
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.favoriteButton addGestureRecognizer:tapGestureRecognizer];
    self.favoriteButton.userInteractionEnabled = YES;
}

- (void)imageTapped:(UITapGestureRecognizer *)sender {
    if (!self.isFavorite) {
        self.favoriteButton.image = [UIImage systemImageNamed:@"star.fill"];
        [[CoreDataManager sharedInstance] createFavorites:self.result];
        self.isFavorite = YES;
    } else {
        self.favoriteButton.image = [UIImage systemImageNamed:@"star"];
        self.isFavorite = NO;
        [[CoreDataManager sharedInstance] removeFavorites:self.result];
    }
}

#pragma mark - Detail movie
- (void)initDetailMovie {
    self.title = self.result.title;
    [self.imgMovie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageURL, self.result.imgURL]]];
    self.overviewTextView.text = self.result.overView;
    self.ratinglbl.text = [self.result.rating stringValue];
    self.releaseDatelbl.text = self.result.releaseDate;
}


#pragma mark - Cast and Crew
- (void)initCastAndCrew {
    [[NetworkManager sharedInstance]fetchCastAndCrew:self.result.iD withCompletion:^(NSDictionary *response) {
        NSArray<Cast *> *Casts= response[@"cast"];
        NSArray<Crew *> *Crews = response[@"crew"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for(NSDictionary *castDict in Casts) {
            if (castDict[@"profile_path"]  != [NSNull null]) {
                [arr addObject: castDict[@"profile_path"]];
            }
        }
        
        for(NSDictionary *crewDict in Crews) {
            if (crewDict[@"profile_path"]  != [NSNull null]) {
                [arr addObject:crewDict[@"profile_path"]];
            }
        }
        NSSet *uniqueSet = [NSSet setWithArray:arr];
        self.castAndCrewArr = [uniqueSet allObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{;
            [self.collectionViewCastAndCrew reloadData];
        });
    }];
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLCastAndCrewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"castAndCrewCell" forIndexPath:indexPath];
    [cell configCastAndCrewCell:self.castAndCrewArr[indexPath.row]];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.castAndCrewArr.count;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDelegateFlowlayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect bounds = [UIScreen.mainScreen bounds];
    CGFloat width = (bounds.size.width-10)/4;
    return CGSizeMake(width, width);
}

- (void)dealloc {
    // Unsubscribe when view controller is canceled
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

