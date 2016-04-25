//
//  ReaderPDF.h
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReaderPDF : NSObject
+ (instancetype)instance;
- (void)ShowReaderDoccumentWithName:(NSString *)documentFile inVC:(UIViewController *)selfView;
@end
