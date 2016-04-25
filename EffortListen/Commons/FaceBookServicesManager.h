//
//  FaceBookServicesManager.h
//  EBS570
//
//  Created by Tamqn on 2/26/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface FaceBookInformation :NSObject{
    FBSDKLoginManagerLoginResult *result;
}
@property (readonly, copy, nonatomic) NSString *appID;
@property (readonly, copy, nonatomic) NSSet *declinedPermissions;
@property (readonly, copy, nonatomic) NSDate *expirationDate;
@property (readonly, copy, nonatomic) NSSet *permissions;
@property (readonly, copy, nonatomic) NSDate *refreshDate;
@property (readonly, copy, nonatomic) NSString *tokenString;
@property (readonly, copy, nonatomic) NSString *userID;
- (instancetype)initWith:(FBSDKLoginManagerLoginResult*)loginResult;
@end


@class FaceBookInformation;
static NSString *faceBookSchemes = @"fb1040136779400633";

@interface FaceBookServicesManager : NSObject {
    FaceBookInformation *faceInfo;
}
+ (FaceBookServicesManager*)sharedInstance;
+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)loginFaceBookWithPermission:(NSArray *)permissions success:(void(^)(FaceBookInformation *faceInfo))success fail:(void(^)(NSError *error))fail cancel:(void(^)(void))cancel;
- (void)shareLink:(NSString *)link inViewController:(UIViewController*)viewController;
@end
