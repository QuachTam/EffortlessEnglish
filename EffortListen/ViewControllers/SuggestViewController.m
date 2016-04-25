//
//  SuggestViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "SuggestViewController.h"
#import "SuggestService.h"

@interface SuggestViewController ()

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"keySuggestBookPDF", nil);
    self.sendButton.layer.cornerRadius = 4.0;
    self.sendButton.layer.masksToBounds = YES;
    
    self.viewSuggest.layer.cornerRadius = 4.0;
    self.viewSuggest.layer.masksToBounds = YES;
    [self backButton];
    
    [self.sendButton setTitle:NSLocalizedString(@"keySuggest", nil) forState:UIControlStateNormal];
    self.bookNameTextField.placeholder = NSLocalizedString(@"keyName", nil);
    self.bookTypeTextField.placeholder = NSLocalizedString(@"keyType", nil);
    self.linkDownloadTextField.placeholder = NSLocalizedString(@"keyLinkDownload", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)backButton {
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 25, 25)];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isBookNameTextField {
    return (self.bookNameTextField.text.length>0 && self.bookNameTextField.text !=nil);
}

- (BOOL)isBookTypeTextField {
    return (self.bookTypeTextField.text.length>0 && self.bookTypeTextField.text !=nil);
}

- (BOOL)isLinkDownloadTextField {
    return (self.linkDownloadTextField.text.length>0 && self.linkDownloadTextField.text !=nil);
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

- (IBAction)sendAction:(id)sender {
    AdmodManager *adManager = [AdmodManager sharedInstance];
    adManager.interstitialDidDismissScreen = ^{
        BOOL isValid = YES;
        if (![self isBookNameTextField]) {
            isValid = NO;
            self.bookNameTextField.backgroundColor = [UIColor redColor];
        }else{
            self.bookNameTextField.backgroundColor = [UIColor whiteColor];
        }
        
        if (![self isBookTypeTextField]) {
            isValid = NO;
            self.bookTypeTextField.backgroundColor = [UIColor redColor];
        }else{
            self.bookTypeTextField.backgroundColor = [UIColor whiteColor];
        }
        
        if (![self isLinkDownloadTextField]) {
            isValid = NO;
            self.linkDownloadTextField.backgroundColor = [UIColor redColor];
        }else{
            self.linkDownloadTextField.backgroundColor = [UIColor whiteColor];
        }
        
        if (isValid) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"keySending", nil)];
            SuggestService *service = [SuggestService instance];
            [service checkDeviceBlock:^(BOOL isBlock) {
                if (!isBlock) {
                    [service sendSuggestBook:self.bookNameTextField.text bookType:self.bookTypeTextField.text linkDownload:self.linkDownloadTextField.text success:^{
                        [SVProgressHUD dismiss];
                        [CommonFeature showAlertTitle:NSLocalizedString(@"keyEffortListen", nil) Message:NSLocalizedString(@"keyThanksYourSendSuggest", nil) duration:2.0 showIn:self blockDismissView:nil];
                    } fail:^(NSString *message) {
                        [SVProgressHUD dismiss];
                        [CommonFeature showAlertTitle:NSLocalizedString(@"keyEffortListen", nil) Message:message duration:2.0 showIn:self blockDismissView:nil];
                    }];
                }else{
                    [SVProgressHUD dismiss];
                    [CommonFeature showAlertTitle:NSLocalizedString(@"keyEffortListen", nil) Message:NSLocalizedString(@"keyYourDeviceIsBlocked", nil) duration:3.0 showIn:self blockDismissView:nil];
                }
            }];
        }
    };
    [adManager createAndLoadInterstitial];
}

@end
