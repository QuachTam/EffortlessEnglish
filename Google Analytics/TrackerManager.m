//
//  TrackerManager.m
//  SocialApp
//
//  Created by Tamqn on 3/30/16.
//  Copyright © 2016 Brodev. All rights reserved.
//

#import "TrackerManager.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface TrackerManager ()
@property (nonatomic) id tracker;
@end
@implementation TrackerManager
+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tracker = [[GAI sharedInstance] defaultTracker];
    }
    return self;
}

- (void)trackerScreenViewWithName:(NSString *)name {
    [self.tracker set:kGAIScreenView
           value:name];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
