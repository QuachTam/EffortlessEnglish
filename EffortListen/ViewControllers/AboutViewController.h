//
//  AboutViewController.h
//  EffortListen
//
//  Created by Tamqn on 3/29/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "BaseViewController.h"

@interface AboutViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
- (IBAction)sendEmailAction:(id)sender;

@end
