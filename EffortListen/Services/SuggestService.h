//
//  SuggestService.h
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestService : NSObject
+ (instancetype)instance;
- (void)sendSuggestBook:(NSString *)bookName bookType:(NSString*)bookType linkDownload:(NSString*)linkDownload success:(void(^)(void))success fail:(void(^)(NSString *message))fail;
- (void)checkDeviceBlock:(void(^)(BOOL isBlock))success;
@end
