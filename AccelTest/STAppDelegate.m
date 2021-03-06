//
//  STAppDelegate.m
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import "STAppDelegate.h"
#import "STAppDelegate.h"
#import "STSessionManager.h"
#import "STAuthBasic.h"
#import <UDPushAuth/UDAuthTokenRetriever.h>
//#import "STHTLapTracker.h"
#import <STManagedTracker/STBatteryTracker.h>

@implementation STAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [[STAuthBasic sharedOAuth] checkToken];
    
    self.pushNotificatonCenter = [UDPushNotificationCenter sharedPushNotificationCenter];
    self.authCodeRetriever = (UDPushAuthCodeRetriever *)[(UDAuthTokenRetriever *)[[STAuthBasic sharedOAuth] tokenRetriever] codeDelegate];
    self.reachability = [Reachability reachabilityWithHostname:[[STAuthBasic sharedOAuth] reachabilityServer]];
    self.reachability.reachableOnWWAN = YES;
    [self.reachability startNotifier];
    
    
    NSDictionary *sessionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"-2", @"desiredAccuracy",
                                     @"10", @"requiredAccuracy",
                                     @"-1", @"distanceFilter",
                                     @"0.0", @"timeFilter",
                                     nil];
    
//    NSDictionary *trackers = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [[STHTLapTracker alloc] init], @"locationTracker",
//                              nil];
    
    [[STSessionManager sharedManager] startSessionForUID:@"1" authDelegate:[STAuthBasic sharedOAuth] trackers:nil settings:sessionSettings];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
#if DEBUG
    NSLog(@"Device token: %@", deviceToken);
#endif
    [self.authCodeRetriever registerDeviceWithPushToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
#if DEBUG
    NSLog(@"Failed to get token, error: %@", error);
#endif
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self.pushNotificatonCenter processPushNotification:userInfo];
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[STSessionManager sharedManager] cleanCompletedSessions];
}

@end
