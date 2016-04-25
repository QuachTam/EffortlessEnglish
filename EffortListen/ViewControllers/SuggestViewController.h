//
//  SuggestViewController.h
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SuggestViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *bookNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bookTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *linkDownloadTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewSuggest;

@end
