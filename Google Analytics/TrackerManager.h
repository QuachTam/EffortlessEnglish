//
//  TrackerManager.h
//  SocialApp
//
//  Created by Tamqn on 3/30/16.
//  Copyright © 2016 Brodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackerManager : NSObject
+ (instancetype)instance;
- (void)trackerScreenViewWithName:(NSString *)name;
@end
