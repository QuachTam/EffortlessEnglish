//
//  CommonFeature.m
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "CommonFeature.h"

@implementation CommonFeature

+ (CommonFeature*)shareInstance {
    static CommonFeature *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[CommonFeature alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldRotate = NO;
    }
    return self;
}

+ (void)setShadownWithBoderWidth:(NSInteger)width view:(UIView*)view{
    CGRect frames = view.bounds;
    frames.origin.x -=width;
    frames.origin.y -=width;
    frames.size.width = frames.size.width + width*2;
    frames.size.height = frames.size.height + width*2;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:frames];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.2f;
    view.layer.shadowPath = shadowPath.CGPath;
}

+ (NSTimeInterval)convertDateToLongtime:(NSDate*)date {
    NSTimeInterval timeInMiliseconds = [date timeIntervalSince1970];
    return timeInMiliseconds;
}

+ (NSDate*)convertLongtimeToDate:(NSTimeInterval)timeInMiliseconds {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInMiliseconds];
    return date;
}

+ (NSString*)convertDateToString:(NSDate *)date withFormat:(NSString*)formatDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatDate];
    //Optionally for time zone converstions
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSInteger)getYearFormDate:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:date];
    NSInteger year  = [components year];
    return year;
}

+ (NSInteger)getMonthFormDate:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:date];
    NSInteger month  = [components month];
    return month;
}

+ (void)showAlertTitle:(NSString*)title Message:(NSString *)message duration:(NSInteger)duration showIn:(id)supperView blockDismissView:(void(^)(void))block{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [supperView presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
            // do something ?
            if (block) {
                block();
            }
        }];
    });
}

+ (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize {
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)imageWithImage:(UIImage*) sourceImage scaledToWidth: (float) i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)deviceUUID
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]])
        return [[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
    
    @autoreleasepool {
        CFUUIDRef uuidReference = CFUUIDCreate(nil);
        CFStringRef stringReference = CFUUIDCreateString(nil, uuidReference);
        NSString *uuidString = (__bridge NSString *)(stringReference);
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuidReference);
        CFRelease(stringReference);
        return uuidString;
    }
}
@end
