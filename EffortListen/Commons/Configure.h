//
//  Configure.h
//  EffortListen
//
//  Created by Quach Tam on 4/13/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configure : NSObject
@property (nonatomic, strong) NSString *linkStore;
@property (nonatomic, strong) NSString *clientAppID;
+ (instancetype)instance;
@end
