//
//  TQNDocument.h
//  EffortListen
//
//  Created by Tamqn on 3/25/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQNDocument : NSObject
+ (instancetype)instance;
- (NSString *)getDocumentsPath;

- (NSString *)getFileInDirectory:(NSString *)directory fileName:(NSString *)fileName; // if directory nil --> get in root document
- (NSError *)saveFileToDocument:(NSData *)data directory:(NSString *)directory fileName:(NSString*)fileName; // if directory nil --> save in root document
- (BOOL)checkFileExist:(NSString *)directory fileName:(NSString*)fileName; // // if directory nil --> check in root document
@end
