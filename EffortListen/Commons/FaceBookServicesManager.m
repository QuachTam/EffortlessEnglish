//
//  FaceBookServicesManager.m
//  EBS570
//
//  Created by Tamqn on 2/26/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "FaceBookServicesManager.h"

@implementation FaceBookInformation

- (instancetype)initWith:(FBSDKLoginManagerLoginResult*)loginResult {
    self = [super init];
    if (self) {
        result = loginResult;
    }
    return self;
}

- (NSString *)appID {
    return result.token.appID;
}

- (NSSet *)declinedPermissions {
    return result.token.declinedPermissions;
}

- (NSDate *)expirationDate {
    return result.token.expirationDate;
}

- (NSSet *)permissions {
    return result.token.permissions;
}

- (NSDate *)refreshDate {
    return result.token.refreshDate;
}

- (NSString *)tokenString {
    return result.token.tokenString;
}

- (NSString *)userID {
    return result.token.userID;
}
@end

@implementation FaceBookServicesManager
+ (FaceBookServicesManager*)sharedInstance {
    static FaceBookServicesManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FaceBookServicesManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

//@[@"public_profile", @"email", @"user_friends"]
- (void)loginFaceBookWithPermission:(NSArray *)permissions success:(void(^)(FaceBookInformation *faceInfo))success fail:(void(^)(NSError *error))fail cancel:(void(^)(void))cancel{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:permissions fromViewController:[self getCurrentViewController] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            if (fail) {
                fail(error);
            }
        } else if (result.isCancelled) {
            if (cancel) {
                cancel();
            }
        } else {
            faceInfo = [[FaceBookInformation alloc] initWith:result];
            if (success) {
                success (faceInfo);
            }
        }
    }];
}

- (void)shareLink:(NSString *)link inViewController:(UIViewController*)viewController{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link];
    [FBSDKShareDialog showFromViewController:viewController
                                 withContent:content
                                    delegate:nil];
}

#pragma mark getCurrentViewController
- (id)getCurrentViewController {
    id WindowRootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    id currentViewController = [self findTopViewController:WindowRootVC];
    return currentViewController;
}

- (id)findTopViewController:(id)inController {
    if ([inController isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[inController selectedViewController]];
    } else if ([inController isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[inController visibleViewController]];
    } else if ([inController isKindOfClass:[UIViewController class]]) {
        return inController;
    } else {
        NSLog(@"Unhandled ViewController class : %@",inController);
        return nil;
    }
}

@end
