//
//  SEGNielsenDCRAppDelegate.m
//  Segment-Nielsen-DCR
//
//  Created by ladanazita on 07/19/2017.
//  Copyright (c) 2017 ladanazita. All rights reserved.
//

#import "SEGNielsenDCRAppDelegate.h"
#import "SEGNielsenDCRIntegrationFactory.h"
#import <Analytics/SEGAnalytics.h>
//#import <NielsenAppApi/NielsenAppApi.h>


@implementation SEGNielsenDCRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"sQ2TwsXLgHmsHtK1pI4uf0cRfE7bR9a7"];
    [config use:[SEGNielsenDCRIntegrationFactory instance]];
    [SEGAnalytics setupWithConfiguration:config];
    [[SEGAnalytics sharedAnalytics] track:@"Video Playback Started"];
    [[SEGAnalytics sharedAnalytics] track:@"Video Content Started"
                           properties: @{ @"full_episode": @true, @"tms_video_id": @"3ru239ur829u4u8t480248w" }
                              options: @{
                                @"integrations": @{
                                        @"nielsen-dcr": @{
                                          @"pipmode": @"2017-05-22",
                                          @"adLoadType": @"c3 value",
                                          @"channelName": @"c4 value",
                                          @"mediaUrl": @"c6 value",
                                          @"hasAds": @true,
                                          @"crossId1": @"cross id1 value",
                                          @"crossId2": @"cross id2 value"
                                         }
                                       }
                            }];

    [[SEGAnalytics sharedAnalytics] track:@"Video Ad Started"
                           properties: @{ @"type": @"pre-roll", @"full_episode": @true, @"tms_video_id": @"3ru239ur829u4u8t480248w",
                                          @"content": @{
                                            @"title": @"Hello World"
                                          }}
                              options: @{
                                @"integrations": @{
                                        @"nielsen-dcr": @{
                                          @"pipmode": @"2017-05-22",
                                          @"adLoadType": @"c3 value",
                                          @"channelName": @"c4 value",
                                          @"mediaUrl": @"c6 value",
                                          @"hasAds": @true,
                                          @"crossId1": @"cross id1 value",
                                          @"crossId2": @"cross id2 value"
                                         }
                                       }
                            }];

    [[SEGAnalytics sharedAnalytics] flush];
    [SEGAnalytics debug:YES];

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
