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
            [SVProgressHUD dismiss];
            [strongSelf performSegueWithIdentifier:@"loginSegue" sender:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
        
        QBUpdateUserParameters *updateParameters = [QBUpdateUserParameters new];
        updateParameters.website = @"www.mysite.com";
        updateParameters.phone = @"0974662046";
        NSDictionary *contentDictionary = @{@"linkAppstore":@""};
        NSData *data = [NSJSONSerialization dataWithJSONObject:contentDictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
        updateParameters.customData = jsonStr;
        
        [QBRequest updateCurrentUser:updateParameters successBlock:^(QBResponse *response, QBUUser *user) {
            NSLog(@"sdfsdf");
        } errorBlock:^(QBResponse *response) {
            NSLog(@"ssssss");
        }];
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
