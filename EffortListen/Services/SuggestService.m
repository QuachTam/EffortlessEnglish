//
//  SuggestService.m
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "SuggestService.h"

@interface SuggestService ()
@property (nonatomic, strong) NSMutableArray *propertyNeedCheck;
@property (nonatomic, strong) NSMutableArray *valueNeedCheck;
@property (nonatomic,copy, readwrite) void(^didCompleteCheck)(BOOL isExist);
@end

@implementation SuggestService
+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}
- (void)sendSuggestBook:(NSString *)bookName bookType:(NSString*)bookType linkDownload:(NSString*)linkDownload success:(void(^)(void))success fail:(void(^)(NSString *message))fail{
    self.valueNeedCheck = [NSMutableArray arrayWithArray:@[bookName, linkDownload]];
    self.propertyNeedCheck = [NSMutableArray arrayWithObjects:@"bookName", @"linkDownload", nil];
    self.didCompleteCheck = ^(BOOL isExist) {
        if (isExist) {
            if (fail) {
                fail(@"File is exist");
            }
        }else{
            QBCOCustomObject *customObject = [QBCOCustomObject new];
            customObject.className = @"Suggest";
            customObject.fields[@"bookName"] = bookName;
            customObject.fields[@"bookType"] = bookType;
            customObject.fields[@"linkDownload"] = linkDownload;
            customObject.fields[@"uuidDevice"] = [CommonFeature deviceUUID];
            [QBRequest createObject:customObject successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
                if (success) {
                    success();
                }
            } errorBlock:^(QBResponse * _Nonnull response) {
                if (fail) {
                    fail(@"Server error");
                }
            }];
        }
    };
    
    [self startRequest];
}

- (void)startRequest {
    __block BOOL fileExist = NO;
    if (self.propertyNeedCheck.count) {
        NSString *value = [self.valueNeedCheck objectAtIndex:0];
        NSString *key = [self.propertyNeedCheck objectAtIndex:0];
        [self checkSuggest:value key:key success:^(BOOL isExist) {
            fileExist = isExist;
            if (isExist) {
                if (self.didCompleteCheck) {
                    self.didCompleteCheck(YES);
                }
            }else{
                [self startRequest];
            }
        }];
    }else{
        if (self.didCompleteCheck) {
            self.didCompleteCheck(fileExist);
        }
    }
}

- (void)checkSuggest:(NSString *)bookName key:(NSString*)key success:(void(^)(BOOL isExist))success {
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:bookName forKey:key];
    [QBRequest objectsWithClassName:@"Suggest" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        [self.propertyNeedCheck removeObjectAtIndex:0];
        [self.valueNeedCheck removeObjectAtIndex:0];
        if (objects.count) {
            if (success) {
                success(YES);
            }
        }else{
            if (success) {
                success(NO);
            }
        }
    } errorBlock:^(QBResponse *response) {
        if (success) {
            success(YES);
        }
    }];
}

- (void)checkDeviceBlock:(void(^)(BOOL isBlock))success {
    [QBRequest objectsWithClassName:@"BlockDevice" successBlock:^(QBResponse * _Nonnull response, NSArray * _Nullable objects) {
        if (objects.count) {
            QBCOCustomObject *customObject = [objects firstObject];
            if ([self isBlockWithArrayDevice:customObject.fields[@"uuidDevice"]]) {
                if (success) {
                    success(YES);
                }
            }else{
                if (success) {
                    success(NO);
                }
            }
        }else{
            if (success) {
                success(NO);
            }
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        if (success) {
            success(NO);
        }
    }];
}

- (BOOL)isBlockWithArrayDevice:(NSArray *)arrayBlock {
    BOOL isBlock = NO;
    NSString *currentDevice = [CommonFeature deviceUUID];
    if ([arrayBlock containsObject:currentDevice]) {
        isBlock = YES;
    }
    return isBlock;
}


@end
