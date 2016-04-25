//
//  CommonFeature.h
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *format_date_type_yyyy_mm_dd_hh_mm = @"dd-MM-yyyy HH:mm";
static NSString *format_date_type_dd_mm_yyyy = @"dd-MM-yyyy";

@interface CommonFeature : NSObject
@property (assign, nonatomic) BOOL shouldRotate;
+ (CommonFeature*)shareInstance;
+ (void)setShadownWithBoderWidth:(NSInteger)width view:(UIView*)view;
+ (NSString*)convertDateToString:(NSDate *)date withFormat:(NSString*)formatDate;
+ (NSTimeInterval)convertDateToLongtime:(NSDate*)date;
+ (NSDate*)convertLongtimeToDate:(NSTimeInterval)timeInMiliseconds;
+ (NSInteger)getYearFormDate:(NSDate *)date;
+ (NSInteger)getMonthFormDate:(NSDate *)date;
+ (void)showAlertTitle:(NSString*)title Message:(NSString *)message duration:(NSInteger)duration showIn:(id)supperView blockDismissView:(void(^)(void))block;
+ (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
+ (UIImage*)imageWithImage:(UIImage*) sourceImage scaledToWidth: (float) i_width;
+ (NSString *)deviceUUID;
@end
