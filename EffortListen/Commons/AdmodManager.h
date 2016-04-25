//
//  AdmodManager.h
//  QuickBlox
//
//  Created by Tamqn on 3/10/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdmodManager : NSObject
@property (nonatomic, copy, readwrite) void(^interstitialDidDismissScreen)();
+ (AdmodManager*)sharedInstance;
- (void)createAndLoadInterstitial;
- (void)showAdmodInViewController;
- (void)showAdmodInTopThisViewController:(UIViewController *)controller;
@end
