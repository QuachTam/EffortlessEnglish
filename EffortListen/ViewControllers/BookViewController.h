//
//  BookViewController.h
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BookViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, strong) QBCOCustomObject *customObject;
@end
