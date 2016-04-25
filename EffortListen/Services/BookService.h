//
//  BookService.h
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookService : NSObject
+ (instancetype)instance;
- (void)downloadFileWith:(NSInteger)blobID statusBlock:(void(^)(QBRequestStatus * status))statusBlock success:(void(^)(BOOL isSuccess))success;
- (void)getListItem:(NSArray *)arrayID success:(void(^)(NSArray * objects))success fail:(void(^)(QBResponse * response))fail;
- (void)requestBlobWithID:(NSInteger)ID success:(void(^)(QBCBlob *blob))success;
@end
