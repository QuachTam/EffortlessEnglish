//
//  Configure.m
//  EffortListen
//
//  Created by Quach Tam on 4/13/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "Configure.h"

@implementation Configure
+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}
@end
