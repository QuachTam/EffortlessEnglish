//
//  FolderTableViewCell.h
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "CustomCellCommon.h"
#import "RWLabel.h"

@interface FolderTableViewCell : CustomCellCommon
@property (weak, nonatomic) IBOutlet RWLabel *name;
@property (weak, nonatomic) IBOutlet UILabel *numberBook;
@property (weak, nonatomic) IBOutlet UIButton *buttonRun;

@end
