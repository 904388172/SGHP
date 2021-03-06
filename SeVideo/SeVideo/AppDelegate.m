//
//  AppDelegate.m
//  SeVideo
//
//  Created by 耿双 on 2019/11/7.
//  Copyright © 2019 GS. All rights reserved.
//


#import "AppDelegate.h"
#import "GSTabBarViewController.h"
#import "GSUserDefaultStatus.h"
#import "GSLoginViewController.h"
#import "GSBaseNavViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //如果登录状态当然要显示home页面
    if ([GSUserDefaultStatus isLogin] == YES) {
        
        GSTabBarViewController *mainVC = [[GSTabBarViewController alloc] init];
        self.window.rootViewController = mainVC;
        
    } else if ([GSUserDefaultStatus isLogin] == NO){
        //如果不是登录状态要到登录界面
        GSLoginViewController *vc = [[GSLoginViewController alloc] init];
        GSBaseNavViewController* navigation = [[GSBaseNavViewController alloc] initWithRootViewController:vc];
        
        self.window.rootViewController = navigation;
    }
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
