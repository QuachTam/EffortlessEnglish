//
//  LoginViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "LoginViewController.h"
#import "StartAppManager.h"

@interface LoginViewController (){
   
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)gotoApp {
    if ([self isNetworkAvailable]) {
        QBUUser *currentUser = [QBUUser new];
        currentUser.email = @"mr.tamqn87hb@gmail.com";
        currentUser.password = @"Quachtam87";
        [SVProgressHUD showWithStatus:NSLocalizedString(@"keyLoggingIn", nil)];
        __weak __typeof(self)weakSelf = self;
        [QMServicesManager.instance logInWithUser:currentUser completion:^(BOOL success, NSString *errorMessage) {
            if (success) {
                [SVProgressHUD dismiss];
                [weakSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Error"];
            }
            
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   StartAppManager *startappManager = [StartAppManager instance];
    [startappManager clickShowLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    StartAppManager *startappManager = [StartAppManager instance];
    [startappManager startAppAd_autoLoad];
    [startappManager startAppBanner_auto:self];
    [self performSelector:@selector(gotoApp) withObject:nil afterDelay:2.0];
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
