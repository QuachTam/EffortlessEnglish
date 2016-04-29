//
//  StartAppManager.h
//  EffortListen
//
//  Created by tamqn on 4/29/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StartApp/StartApp.h>

@interface StartAppManager : NSObject
+ (instancetype)instance;
- (void)startAppAd_autoLoad;
- (void)clickShowLoad;
- (void)startAppBanner_auto:(UIViewController*)selfVC;
- (void)startAppBanner_fixed:(UIViewController*)selfVC;
@end
