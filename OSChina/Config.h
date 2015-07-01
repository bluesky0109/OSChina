//
//  Config.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

+ (void)saveUserAccount:(NSString *)account andPassword:(NSString *)password;
+ (void)saveUserID:(int64_t)userID;

+ (NSArray *)getUserAccountAndPassword;
+ (NSString *)getUserID;

@end
