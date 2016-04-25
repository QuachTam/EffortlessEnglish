//
//  FolderViewController.h
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "BaseViewController.h"

@interface FolderViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end
