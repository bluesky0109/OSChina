//
//  Utils.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Util.h"
#import "UIColor+Util.h"
#import "UIImageView+Util.h"
#import "UIImage+Util.h"
#import "NSTextAttachment+Util.h"
#import <MBProgressHUD.h>

static NSString * const kKeyYears = @"years";
static NSString * const kKeyMonths = @"months";
static NSString * const kKeyDays = @"days";
static NSString * const kKeyHours = @"hours";
static NSString * const kKeyMinutes = @"minutes";

typedef NS_ENUM(NSUInteger, hudType) {
    hudTypeSendingTweet,
    hudTypeLoading,
    hudTypeCompleted
};

@interface Utils : NSObject

+ (NSAttributedString *)getAppclient:(int)clientType;
+ (NSString *)generateRelativeNewsString:(NSArray *)relativeNews;
+ (NSString *)GenerateTags:(NSArray *)tags;
+ (void)analysis:(NSString *)url andNavController:(UINavigationController *)navigationController;

+ (NSDictionary *)timeIntervalArrayFromString:(NSString *)dateStr;

+ (NSAttributedString *)attributedTimeString:(NSString *)dateStr;

+ (NSAttributedString *)attributedCommentCount:(int)commentCount;

+ (NSString *)intervalSinceNow:(NSString *)dateStr;

+ (NSString *)getWeekdayFromDateComponents:(NSDateComponents *)dateComps;

+ (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date;

+ (NSAttributedString *)emojiStringFromRawString:(NSString *)rawString;

+ (NSData *)compressImage:(UIImage *)image;

+ (NSString *)convertRichTextToRawText:(UITextView *)textView;

+ (NSString *)escapeHTML:(NSString *)originalHTML;

+ (NSString *)deleteHTMLTag:(NSString *)HTML;

+ (BOOL)isURL:(NSString *)string;

+ (NSInteger)networkStatus;

+ (BOOL)isNetworkExitst;

+ (CGFloat)valueBetweenMin:(CGFloat)min andMax:(CGFloat)max percent:(CGFloat)percent;

+ (MBProgressHUD *)createHUD;

+ (UIImage *)createQRCodeFromString:(NSString *)string;

@end
