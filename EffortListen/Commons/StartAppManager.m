//
//  StartAppManager.m
//  EffortListen
//
//  Created by tamqn on 4/29/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "StartAppManager.h"

@interface StartAppManager ()<STADelegateProtocol, STABannerDelegateProtocol>{
    STAStartAppAd *startAppAd_autoLoad;
    STAStartAppAd *startAppAd_loadShow;
}

@end

@implementation StartAppManager

+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        startAppAd_autoLoad = [[STAStartAppAd alloc] init];
        startAppAd_loadShow = [[STAStartAppAd alloc] init];
    }
    return self;
}

#pragma mark STARTAPPAD_AUTOLOAD
- (void)startAppAd_autoLoad{
    // loading the StartApp Ad
    [startAppAd_autoLoad loadAdWithDelegate:self];
}

- (void)clickShowLoad{
    [startAppAd_autoLoad showAd];
}

- (void)startAppBanner_auto:(UIViewController*)selfVC{
    STABannerView *startAppBanner_auto = [[STABannerView alloc] initWithSize:STA_AutoAdSize
                                                                  autoOrigin:STAAdOrigin_Bottom
                                                                    withView:selfVC.view withDelegate:self];
    [selfVC.view addSubview:startAppBanner_auto];
}

- (void)startAppBanner_fixed:(UIViewController*)selfVC{
    STABannerView *startAppBanner_fixed;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        startAppBanner_fixed = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_768x90
                                                            origin:CGPointMake(0,300)
                                                          withView:selfVC.view withDelegate:self];
    } else {
        startAppBanner_fixed = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_320x50
                                                            origin:CGPointMake(0,200)
                                                          withView:selfVC.view withDelegate:self];
    }
    
    [selfVC.view addSubview:startAppBanner_fixed];
}

- (void) didDisplayBannerAd:(STABannerView*)banner {
    NSLog(@"didDisplayBannerAd");
}

- (void) failedLoadBannerAd:(STABannerView*)banner withError:(NSError *)error {
    NSLog(@"failedLoadBannerAd : %@", error);
}

- (void) didClickBannerAd:(STABannerView*)banner {
    NSLog(@"didClickBannerAd");
}

- (void) didCloseBannerInAppStore:(STABannerView*)banner {
     NSLog(@"didCloseBannerInAppStore");
}

#pragma mark STADelegateProtocol methods
/*
 Implementation of the STADelegationProtocol.
 All methods here are optional and you can
 implement only the ones you need.
 */

// StartApp Ad loaded successfully
- (void) didLoadAd:(STAAbstractAd*)ad {
    NSLog(@"StartApp Ad had been loaded successfully");
    // Show the Ad
    if (startAppAd_loadShow == ad) {
        [startAppAd_loadShow showAd];
    }
}

// StartApp Ad failed to load
- (void) failedLoadAd:(STAAbstractAd*)ad withError:(NSError *)error{
    NSLog(@"StartApp Ad had failed to load");
}

// StartApp Ad is being displayed
- (void) didShowAd:(STAAbstractAd*)ad {
    NSLog(@"StartApp Ad is being displayed");
}

// StartApp Ad failed to display
- (void) failedShowAd:(STAAbstractAd*)ad withError:(NSError *)error {
    
    NSLog(@"StartApp Ad is failed to display");
    if (startAppAd_autoLoad == ad) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can't show ad" message:@"Ad is not loaded yet, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) didClickAd:(STAAbstractAd*)ad {
    
}

- (void) didCloseInAppStore:(STAAbstractAd*)ad {
    
}

- (void) didCompleteVideo:(STAAbstractAd*)ad {
    
}

- (void) didCloseAd:(STAAbstractAd*)ad {
    if (startAppAd_autoLoad == ad) {
        [startAppAd_autoLoad loadAdWithDelegate:self];
    }
}


@end
