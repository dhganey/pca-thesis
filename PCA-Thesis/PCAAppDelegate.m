//
//  PCAAppDelegate.m
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAAppDelegate.h"

#import "Catalyze.h"

@implementation PCAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Setup Catalyze
    [Catalyze setApiKey:@"ios pca 2f708c6f-0ab6-429b-a056-d01622b1ea69" applicationId:@"5735e7c5-2669-4778-afa4-64cf7e5707a6"];
    
    [Catalyze setLoggingLevel:kLoggingLevelDebug]; //comment this line out when deploying! used for high level of logging
    
    //change status bar to dark
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //set navigation bar color
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:RED/BASE green:GREEN/BASE blue:BLUE/BASE alpha:ALPHA]];
    
    //make nav title white
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //make back buttons white
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //prepare background image
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper-1-white-blue.jpg"]];
//    imageView.frame = _window.frame;
//    [_window addSubview:imageView];
//    [imageView.superview sendSubviewToBack:imageView];
    
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
