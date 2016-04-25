//
//  ModelItem.h
//  QuickBlox
//
//  Created by Quach Tam on 2/3/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelItem : NSObject
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *bookIDs;
@end
