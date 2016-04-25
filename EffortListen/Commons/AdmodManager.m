//
//  AdmodManager.m
//  QuickBlox
//
//  Created by Tamqn on 3/10/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
@class GADBannerView;
@import GoogleMobileAds;

static NSString *ClientAppID = @"ca-app-pub-9259023205127043/7494555614";

#import "AdmodManager.h"
#import <PureLayout/PureLayout.h>

const NSInteger showAdTop =0;
const NSInteger showAdBottom = 1;

@interface AdmodManager ()<GADInterstitialDelegate>
/// The DFP interstitial ad.
@property(nonatomic, strong) DFPInterstitial *interstitial;
@end

@implementation AdmodManager

+ (AdmodManager*)sharedInstance {
    static AdmodManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AdmodManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showAdmodInTopThisViewController:(UIViewController *)controller {
    [self showAdmod:showAdTop inViewController:controller];
}

- (void)showAdmodInViewController{
    UIViewController *root = [self getCurrentViewController];
    [self showAdmod:showAdBottom inViewController:root];
}

- (void)showAdmod:(NSInteger)type inViewController:(UIViewController *)parent{
    UIView *viewBannerAdMod = [[UIView alloc] initForAutoLayout];
    GADBannerView *bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = ClientAppID;
    bannerView_.rootViewController = parent;
    bannerView_.autoloadEnabled = YES;
    GADRequest *request = [GADRequest request];
//    request.testDevices = [NSArray arrayWithObjects:@"Simulator",nil];
    [bannerView_ loadRequest:request];
    [viewBannerAdMod addSubview:bannerView_];
    if (type==showAdTop) {
        [parent.view insertSubview:viewBannerAdMod atIndex:0];
    }else {
        [parent.view addSubview:viewBannerAdMod];
    }
    
    [viewBannerAdMod autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [viewBannerAdMod autoSetDimension:ALDimensionHeight toSize:kGADAdSizeBanner.size.height];
    [viewBannerAdMod autoSetDimension:ALDimensionWidth toSize:parent.view.frame.size.width];
    if (type==showAdTop) {
        [viewBannerAdMod autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }else{
        [viewBannerAdMod autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    
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

#pragma mark createAndLoadInterstitial
- (void)createAndLoadInterstitial {
    self.interstitial = [[DFPInterstitial alloc] initWithAdUnitID:ClientAppID];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
//    request.testDevices = [NSArray arrayWithObjects:@"Simulator",nil];
    [self.interstitial loadRequest:request];
}

#pragma mark GADInterstitialDelegate implementation

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [self.interstitial presentFromRootViewController:[self getCurrentViewController]];
}

- (void)interstitial:(DFPInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
    if (self.interstitialDidDismissScreen) {
        self.interstitialDidDismissScreen();
    }
}

- (void)interstitialDidDismissScreen:(DFPInterstitial *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
    if (self.interstitialDidDismissScreen) {
        self.interstitialDidDismissScreen();
    }
}

@end
