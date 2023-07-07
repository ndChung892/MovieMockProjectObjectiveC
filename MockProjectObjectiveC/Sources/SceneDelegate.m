//
//  SceneDelegate.m
//  MockProjectObjectiveC
//
//  Created by Chung on 21/06/2023.
//

#import "SceneDelegate.h"
#import "SLTabbarController.h"
#import "SLLeftMenuViewController.h"
#import "SLAboutViewController.h"
#import "SLSettingsViewController.h"
#import "SLFavoritesViewController.h"
#import "SLMoviesViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    UIViewController *launchScreenVC = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateInitialViewController];
    
    self.window.rootViewController = launchScreenVC;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // Chuyển sang giao diện chính của ứng dụng
        SLTabbarController *tabbar = [[SLTabbarController alloc] init];
        SLLeftMenuViewController *leftMenuVC = [[SLLeftMenuViewController alloc]init];
        
        SWRevealViewController *reveal = [[SWRevealViewController alloc]initWithRearViewController: leftMenuVC frontViewController:tabbar];
        self.window.rootViewController = reveal;
    });
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
