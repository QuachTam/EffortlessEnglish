//
//  PlaySoundViewController.h
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KRVideoPlayerController.h>
#import "BaseViewController.h"

@interface PlaySoundViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tbView;
- (IBAction)cancelAction:(id)sender;
- (IBAction)readBookAction:(id)sender;
@property (nonatomic, strong) NSArray *bookList;
@property (nonatomic, readwrite) NSInteger currentIndexBook;

@end
