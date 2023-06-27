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


@interface SLTabbarController ()

@end

@implementation SLTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabbarController];
    
}

- (void)setupTabbarController {
    
    SLMoviesViewController *movieVC = [[SLMoviesViewController alloc] init];
    UINavigationController *navMovie = [[UINavigationController alloc] initWithRootViewController:movieVC];
    [self configViewController: navMovie hasTitle:@"Movies" withIcon:@"house.fill"];
    
    SLFavoritesViewController *favoritesVC = [[SLFavoritesViewController alloc]init];
    UINavigationController *navFavorites = [[UINavigationController alloc] initWithRootViewController:favoritesVC];
    [self configViewController: navFavorites hasTitle:@"Favorites" withIcon: @"heart.fill"];
    
    
    SLSettingsViewController *settingVC = [[SLSettingsViewController alloc]init];
    UINavigationController *navSetting = [[UINavigationController alloc] initWithRootViewController:settingVC];
    [self configViewController:navSetting hasTitle:@"Settings" withIcon:@"gearshape.fill"];
    
    SLAboutViewController *aboutVC = [[SLAboutViewController alloc]init];
    UINavigationController *navAbout = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    [self configViewController:navAbout hasTitle:@"About" withIcon:@"exclamationmark.circle.fill"];
    
    NSArray *controllers = @[navMovie, navFavorites, navSetting, navAbout];
    
    for (id nav in controllers) {
        [[nav navigationBar] setBackgroundColor:[UIColor blueColor]];
        [[nav navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    [self setViewControllers: controllers];
    
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor grayColor];
    self.tabBar.backgroundColor = [UIColor blueColor];
    
}

- (void) configViewController:(UIViewController *)vc hasTitle:(NSString *)title withIcon:(NSString *) imageName {
    UITabBarItem *tabbarItem = vc.tabBarItem;
    [tabbarItem setTitle: title];
    [tabbarItem setImage:[UIImage systemImageNamed: imageName]];
    
}

@end
