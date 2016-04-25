//
//  LoginViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    QBUUser *currentUser = [QBUUser new];
    currentUser.email = @"mr.tamqn87hb@gmail.com";
    currentUser.password = @"Quachtam87";
    [SVProgressHUD showWithStatus:NSLocalizedString(@"keyLoggingIn", nil)];
    __weak __typeof(self)weakSelf = self;
    [QMServicesManager.instance logInWithUser:currentUser completion:^(BOOL success, NSString *errorMessage) {
        if (success) {
            __typeof(self) strongSelf = weakSelf;
            [QBRequest objectsWithClassName:@"Configure" successBlock:^(QBResponse * _Nonnull response, NSArray * _Nullable objects) {
                QBCOCustomObject *object_custom = [objects firstObject];
                NSString *linkStore = object_custom.fields[@"appleLink"];
                NSString *clientAppID = object_custom.fields[@"clientAppID"];
                
                Configure *setup = [Configure instance];
                setup.linkStore = linkStore;
                setup.clientAppID = clientAppID;
                
                [SVProgressHUD dismiss];
                [strongSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
            } errorBlock:^(QBResponse * _Nonnull response) {
                [SVProgressHUD dismiss];
                [strongSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
        
    }];
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
