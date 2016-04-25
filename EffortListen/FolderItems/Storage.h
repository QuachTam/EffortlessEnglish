//
//  Storage.h
//  sample-custom_objects
//
//  Created by Quickblox Team on 6/10/15.
//  Copyright (c) 2015 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kItemClassName @"Folder"

@interface Storage : NSObject

@property (nonatomic, strong) NSMutableArray *folderList;

+ (instancetype)instance;

@end
