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

#pragma mark - SLTabbarController

@interface SLTabbarController ()
@property (nonatomic) UINavigationController *navSetting;
@end

@implementation SLTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor grayColor];
    self.tabBar.backgroundColor = [UIColor blueColor];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configTabbarController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowAllClicked:) name:@"transitionToSetting" object:nil];
}

- (void)handleShowAllClicked:(NSNotification *)notification {
    self.selectedIndex = 2;
    SLShowAllRemindersViewController *showAllVC = [[SLShowAllRemindersViewController alloc]init];
    [self.navSetting pushViewController:showAllVC animated:YES];
}

#pragma mark - configTabbarController
- (void)configTabbarController {
    SLMoviesViewController *movieVC = [[SLMoviesViewController alloc] init];
    SLFavoritesViewController *favoritesVC = [[SLFavoritesViewController alloc]init];
    SLSettingsViewController *settingVC = [[SLSettingsViewController alloc]init];
    SLAboutViewController *aboutVC = [[SLAboutViewController alloc]init];
    
    UINavigationController *navMovie = [[UINavigationController alloc] initWithRootViewController:movieVC];
    UINavigationController *navFavorites = [[UINavigationController alloc] initWithRootViewController:favoritesVC];
     self. navSetting = [[UINavigationController alloc] initWithRootViewController:settingVC];
    UINavigationController *navAbout = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    
    [self configViewController:navMovie hasTitle:@"Movies" withIcon:@"house.fill"];
    [self configViewController:navFavorites hasTitle:@"Favorites" withIcon: @"heart.fill"];
    [self configViewController:self.navSetting hasTitle:@"Settings" withIcon:@"gearshape.fill"];
    [self configViewController:navAbout hasTitle:@"About" withIcon:@"exclamationmark.circle.fill"];
    
    NSArray *controllers = @[navMovie, navFavorites, self.navSetting, navAbout];
    
    for (id nav in controllers) {
        [[nav navigationBar] setBackgroundColor:[UIColor blueColor]];
        [[nav navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [[nav navigationBar] setTintColor:[UIColor whiteColor]];
    }
    
    [self setViewControllers: @[navMovie, navFavorites, self.navSetting, navAbout]];
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
