//
//  LeftCustomCell.h
//  QuickBlox
//
//  Created by Tamqn on 1/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWLabel.h"
#import "CustomCellCommon.h"

@interface LeftCustomCell : CustomCellCommon
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet RWLabel *name;

@end
