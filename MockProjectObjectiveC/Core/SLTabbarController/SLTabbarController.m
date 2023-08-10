//
//  SLTabbarController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 26/06/2023.
//

#import "SLTabbarController.h"
#import "SLAboutViewController.h"
#import "SLSettingsViewController.h"
#import "SLFavoritesViewController.h"
#import "SLMoviesViewController.h"
#import "SLLeftMenuViewController.h"
#import "SLShowAllRemindersViewController.h"
#import <SWRevealViewController.h>
#import "NotificationConstant.h"

#pragma mark - SLTabbarController

@interface SLTabbarController ()
@property (nonatomic) UINavigationController *navSetting;
@property (nonatomic) UINavigationController *navMovie;
@property (nonatomic) UINavigationController *navFavorites;
@property (nonatomic) UINavigationController *navAbout;

@end

@implementation SLTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor blueColor];
    self.tabBar.backgroundColor = [UIColor blueColor];
    [self configTabbarController];
    [self notificationAddObserver];
}

- (void)notificationAddObserver {
    // Display show all viewController
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowAllClicked:) name:NOTIFICATION_LEFTMENU_WILL_SHOW_ALL_REMINDER object:nil];
    
    // Display Detail Movie Viewcontroller from local notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationClicked:) name:NOTIFICATION_DETAIL_MOVIE_WILL_DISPLAY object:nil];
}

#pragma mark - Handle Notification Center
- (void)handleShowAllClicked:(NSNotification *)notification {
    self.selectedIndex = 2;
    SLShowAllRemindersViewController *showAllVC = [[SLShowAllRemindersViewController alloc]init];
    [self.navSetting pushViewController:showAllVC animated:YES];
}

- (void)handleNotificationClicked:(NSNotification *)notification {
    self.selectedIndex = 0;
}


#pragma mark - Config TabbarController
- (void)configTabbarController {
    SLMoviesViewController *movieVC = [[SLMoviesViewController alloc] init];
    SLFavoritesViewController *favoritesVC = [[SLFavoritesViewController alloc]init];
    SLSettingsViewController *settingVC = [[SLSettingsViewController alloc]init];
    SLAboutViewController *aboutVC = [[SLAboutViewController alloc]init];
    
    self.navMovie = [[UINavigationController alloc] initWithRootViewController:movieVC];
    self.navFavorites = [[UINavigationController alloc] initWithRootViewController:favoritesVC];
     self.navSetting = [[UINavigationController alloc] initWithRootViewController:settingVC];
    self.navAbout = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    
    [self configViewController:self.navMovie hasTitle:@"Movies" withIcon:@"house.fill"];
    [self configViewController:self.navFavorites hasTitle:@"Favorites" withIcon: @"heart.fill"];
    [self configViewController:self.navSetting hasTitle:@"Settings" withIcon:@"gearshape.fill"];
    [self configViewController:self.navAbout hasTitle:@"About" withIcon:@"exclamationmark.circle.fill"];
    
    NSArray *controllers = @[self.navMovie, self.navFavorites, self.navSetting, self.navAbout];
    
    for (id nav in controllers) {
        [[nav navigationBar]setBackgroundColor:[UIColor blueColor]];
        [[nav navigationBar]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [[nav navigationBar]setTintColor:[UIColor whiteColor]];
        [[nav navigationBar]setBarTintColor:[UIColor blueColor]];
    }
    
    [self setViewControllers: @[self.navMovie, self.navFavorites, self.navSetting, self.navAbout]];
}

- (void)configViewController:(UIViewController *)vc hasTitle:(NSString *)title withIcon:(NSString *) imageName {
    UITabBarItem *tabbarItem = vc.tabBarItem;
    [tabbarItem setTitle: title];
    [tabbarItem setImage:[UIImage systemImageNamed: imageName]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
