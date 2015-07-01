//
//  Config.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password;
+ (void)saveOwnID:(int64_t)userID;
//+ (void)saveCookie:(BOOL)isLogin;

+ (NSArray *)getOwnAccountAndPassword;
+ (int64_t)getOwnID;

@end
