//
//  AppDelegate.m
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "AppDelegate.h"
#import "FaceBookServicesManager.h"
#import <StartApp/StartApp.h>

const NSUInteger kApplicationID = 37770;
NSString *const kAuthKey        = @"yk27Lrh3MGYkXWG";
NSString *const kAuthSecret     = @"CZFKaV6qzRJGCLC";
NSString *const kAccountKey     = @"dNmL8ohoACNrhHZ6KWAQ";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Set QuickBlox credentials (You must create application in admin.quickblox.com)
    [FaceBookServicesManager application:application didFinishLaunchingWithOptions:launchOptions];
    
    [QBSettings setApplicationID:kApplicationID];
    [QBSettings setAuthKey:kAuthKey];
    [QBSettings setAuthSecret:kAuthSecret];
    [QBSettings setAccountKey:kAccountKey];
    [QBSettings setChatDNSLookupCacheEnabled:YES];
    // Enables Quickblox REST API calls debug console output
    [QBSettings setLogLevel:QBLogLevelDebug];
    
    // Enables detailed XMPP logging in console output
    [QBSettings enableXMPPLogging];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:139/255.0 green:195/255.0 blue:74/255.0 alpha:1],NSForegroundColorAttributeName,[UIColor colorWithRed:139/255.0 green:195/255.0 blue:74/255.0 alpha:1],NSForegroundColorAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],NSForegroundColorAttributeName,[UIFont fontWithName:@"Arial-Bold" size:20],NSFontAttributeName,nil]];
    
    
    // initialize the SDK with your appID and devID
    STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    sdk.appID = @"203121195";
    sdk.devID = @"102434596";
    sdk.preferences = [STASDKPreferences prefrencesWithAge:22 andGender:STAGender_Male];
    
    STASplashPreferences *splashPreferences = [[STASplashPreferences alloc] init];
    splashPreferences.splashMode = STASplashModeTemplate;
    splashPreferences.splashTemplateTheme = STASplashTemplateThemeOcean;
    splashPreferences.splashLoadingIndicatorType = STASplashLoadingIndicatorTypeDots;
    splashPreferences.splashTemplateIconImageName = @"Effortless English";
    splashPreferences.splashTemplateAppName = @"StartApp Effortless English App";
    
    [sdk showSplashAdWithPreferences:splashPreferences];
    
    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    CommonFeature *common = [CommonFeature shareInstance];
    if (!common.shouldRotate) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
}

#pragma mark -
#pragma mark - SCFacebook Handle

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FaceBookServicesManager application:application
                                        openURL:url
                              sourceApplication:sourceApplication
                                     annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
