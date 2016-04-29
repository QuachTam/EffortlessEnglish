//
//  LoginViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
    STAStartAppAd *startAppAd_autoLoad;
    
    /*
     Declaration of STAStartAppAd which later on will be used
     for loading when user clicks on a button and showing the
     loaded ad when the ad was loaded with delegation
     */
    STAStartAppAd *startAppAd_loadShow;
    
    /*
     Declaration of StartApp Banner view with automatic positioning
     */
    STABannerView *startAppBanner_auto;
    
    /*
     Declaration of StartApp Banner view with fixed positioning and size
     */
    STABannerView *startAppBanner_fixed;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([self isNetworkAvailable]) {
//        QBUUser *currentUser = [QBUUser new];
//        currentUser.email = @"mr.tamqn87hb@gmail.com";
//        currentUser.password = @"Quachtam87";
//        [SVProgressHUD showWithStatus:NSLocalizedString(@"keyLoggingIn", nil)];
//        __weak __typeof(self)weakSelf = self;
//        [QMServicesManager.instance logInWithUser:currentUser completion:^(BOOL success, NSString *errorMessage) {
//            if (success) {
//                [SVProgressHUD dismiss];
//                [weakSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
//            } else {
//                [SVProgressHUD showErrorWithStatus:@"Error"];
//            }
//            
//        }];
//    }
    startAppAd_autoLoad = [[STAStartAppAd alloc] init];
    startAppAd_loadShow = [[STAStartAppAd alloc] init];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //
    // loading the StartApp Ad
    [startAppAd_autoLoad loadAdWithDelegate:self];
    
    /*
     load the StartApp auto position banner, banner size will be assigned automatically by  StartApp
     NOTE: replace the ApplicationID and the PublisherID with your own IDs
     */
    if (startAppBanner_auto == nil) {
        startAppBanner_auto = [[STABannerView alloc] initWithSize:STA_AutoAdSize
                                                       autoOrigin:STAAdOrigin_Bottom
                                                         withView:self.view withDelegate:nil];
        [self.view addSubview:startAppBanner_auto];
    }
    
    /*
     load the StartApp fixed position banner - in (0, 200)
     NOTE: replace the ApplicationID and the PublisherID with your own IDs
     */
    if (startAppBanner_fixed == nil) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            startAppBanner_fixed = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_768x90
                                                                origin:CGPointMake(0,300)
                                                              withView:self.view withDelegate:nil];
        } else {
            startAppBanner_fixed = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_320x50
                                                                origin:CGPointMake(0,200)
                                                              withView:self.view withDelegate:nil];
        }
        
        [self.view addSubview:startAppBanner_fixed];
    }
}


#pragma mark STADelegateProtocol methods
/*
 Implementation of the STADelegationProtocol.
 All methods here are optional and you can
 implement only the ones you need.
 */

// StartApp Ad loaded successfully
- (void) didLoadAd:(STAAbstractAd*)ad;
{
    NSLog(@"StartApp Ad had been loaded successfully");
    
    // Show the Ad
    if (startAppAd_loadShow == ad) {
        [startAppAd_loadShow showAd];
    }
}

// StartApp Ad failed to load
- (void) failedLoadAd:(STAAbstractAd*)ad withError:(NSError *)error;
{
    NSLog(@"StartApp Ad had failed to load");
}

// StartApp Ad is being displayed
- (void) didShowAd:(STAAbstractAd*)ad;
{
    NSLog(@"StartApp Ad is being displayed");
}

// StartApp Ad failed to display
- (void) failedShowAd:(STAAbstractAd*)ad withError:(NSError *)error;
{
    
    NSLog(@"StartApp Ad is failed to display");
    if (startAppAd_autoLoad == ad) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can't show ad" message:@"Ad is not loaded yet, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) didCloseAd:(STAAbstractAd*)ad {
    if (startAppAd_autoLoad == ad) {
        [startAppAd_autoLoad loadAdWithDelegate:self];
    }
}

- (BOOL)isNetworkAvailable {
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.apple.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp )
    {
        NSLog (@"Connection is Available");
        return YES;
    }
    else
    {
        NSLog (@"Connection is down");
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
