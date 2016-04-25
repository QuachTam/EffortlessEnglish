//
//  TQNDocument.m
//  EffortListen
//
//  Created by Tamqn on 3/25/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "TQNDocument.h"

@implementation TQNDocument

+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}

- (NSString *)getDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

#pragma mark CREATE
- (void)createDirectory:(NSString *)folderName{
    if (!folderName || folderName.length<=0) {
        return;
    }
    NSString *docPath = [self getDocumentsPath];
    NSString *booksDir = [docPath stringByAppendingPathComponent:folderName];
    NSFileManager *fm =[NSFileManager defaultManager];
    NSError *error;
    if (![fm fileExistsAtPath:booksDir]) {
        [fm createDirectoryAtPath:booksDir withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

#pragma mark GET
- (NSString*)getDirectory:(NSString *)folderName{
    [self createDirectory:folderName];
    NSString *docPath = [self getDocumentsPath];
    NSString *booksDir = docPath;
    if (folderName && folderName.length>0) {
        booksDir = [docPath stringByAppendingPathComponent:folderName];
    }
    return booksDir;
}

#pragma mark SAVE
- (NSError *)saveFileToDocument:(NSData *)data directory:(NSString *)directory fileName:(NSString*)fileName{
    NSError *error = nil;
    NSString *docPath = [self getDirectory:directory];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    return error;
}

#pragma mark GET FILE

- (NSString *)getFileInDirectory:(NSString *)directory fileName:(NSString *)fileName {
    NSString *directoryPath = [self getDirectory:directory];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
    return filePath;
}

#pragma mark CHECK FILE EXIST

- (BOOL)checkFileExist:(NSString *)directory fileName:(NSString*)fileName {
    NSString *docPath = [self getDirectory:directory];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    NSFileManager *fm =[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath]) {
        return NO;
    }
    return YES;
}

@end
