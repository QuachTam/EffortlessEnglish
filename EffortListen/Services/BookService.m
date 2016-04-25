//
//  BookService.m
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "BookService.h"
#import "TQNDocument.h"

@interface BookService ()

@end

@implementation BookService

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
    }
    return self;
}

- (void)getListItem:(NSArray *)arrayID success:(void(^)(NSArray * _Nullable objects))success fail:(void(^)(QBResponse * _Nonnull response))fail{
    [QBRequest objectsWithClassName:@"Item" IDs:arrayID successBlock:^(QBResponse * _Nonnull response, NSArray * _Nullable objects) {
        if (success) {
            success(objects);
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        if (fail) {
            fail(response);
        }
    }];
}

- (void)requestBlobWithID:(NSInteger)ID success:(void(^)(QBCBlob *blob))success {
    [QBRequest blobWithID:ID successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nullable blob) {
        if (success) {
            success (blob);
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        if (success) {
            success (nil);
        }
    }];
}


- (void)downloadFileWith:(NSInteger)blobID statusBlock:(void(^)(QBRequestStatus * status))statusBlock success:(void(^)(BOOL isSuccess))success {
    [QBRequest downloadFileWithID:blobID successBlock:^(QBResponse * _Nonnull response, NSData * _Nonnull fileData) {
        if (fileData) {
            TQNDocument *document = [TQNDocument instance];
            [document saveFileToDocument:fileData directory:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)blobID]];
            if (success) {
                success(YES);
            }
        }else{
            if (success) {
                success(NO);
            }
        }
    } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
        if (statusBlock) {
            statusBlock (status);
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        if (success) {
            success(NO);
        }
    }];
}
@end
