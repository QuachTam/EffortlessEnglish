//
//  ReaderPDF.m
//  EffortListen
//
//  Created by Tamqn on 3/24/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "ReaderPDF.h"
#import "ReaderViewController.h"

@interface ReaderPDF()<ReaderViewControllerDelegate>
@property (nonatomic, strong) UIViewController *rootVC;
@end
@implementation ReaderPDF

+ (instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    
    return instance;
}

- (void)ShowReaderDoccumentWithName:(NSString *)documentFile inVC:(UIViewController *)selfView{
    self.rootVC = selfView;
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:documentFile password:phrase];
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.rootVC presentViewController:readerViewController animated:YES completion:NULL];
    }else {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, documentFile, phrase);
    }
}

#pragma mark - ReaderViewControllerDelegate methods
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self.rootVC dismissViewControllerAnimated:YES completion:NULL];
}


@end
