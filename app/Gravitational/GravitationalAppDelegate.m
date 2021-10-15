//
//  GravitationalAppDelegate.m
//  Gravitational
//
//  Created by Lennart Reiher on 20.02.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "GravitationalAppDelegate.h"
#import "GCHelper.h"
#import "MKStoreManager.h"
#import "GAI.h"
#import "iRate.h"

@implementation GravitationalAppDelegate

+ (void)initialize {
    [iRate sharedInstance].previewMode = NO;
    [iRate sharedInstance].appStoreGenreID = iRateAppStoreGameGenreID;
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 10;
    [iRate sharedInstance].remindPeriod = 2;
    [iRate sharedInstance].useAllAvailableLanguages = NO;
    [iRate sharedInstance].promptForNewVersionIfUserRated = YES;
    [iRate sharedInstance].updateMessage = @"Thank you very much for having rated the app already. However, with a new version of Gravitational installed on your device, you might want to update your rating? You can also choose to never being asked again.";
    [iRate sharedInstance].cancelButtonLabel = @"Never ask me again";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Global globals];
    [GCHelper defaultHelper];
    [MKStoreManager sharedManager];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 60;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-54647581-2"];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
