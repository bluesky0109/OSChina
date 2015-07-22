//
//  Config.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Config : NSObject

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password;

+ (void)saveOwnID:(int64_t)userID userName:(NSString *)userName score:(int)score favoriteCount:(int)favoriteCount fansCount:(int)fanCount andFollowerCount:(int)followerCount;

+ (void)savePortrait:(UIImage *)portrait;

+ (void)saveName:(NSString *)actorName sex:(NSInteger)sex phoneNumber:(NSString *)phoneNumber corporation:(NSString *)corporation andPosition:(NSString *)position;

+ (NSArray *)getOwnAccountAndPassword;

+ (int64_t)getOwnID;

+ (NSString *)getOwnUserName;

+ (NSArray *)getActivitySignUpInfomation;

+ (NSArray *)getUsersInformation;

+ (UIImage *)getPortrait;

@end
