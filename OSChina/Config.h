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

+ (void)saveOwnUserName:(NSString *)userName andUserScore:(int)score andUserFavoriteCount:(int)favoriteCount andUserFans:(int)fans andUserFollower:(int)follower andOwnID:(int64_t)userID;

+ (void)saveActivityActorName:(NSString *)actorName andSex:(NSInteger)sex andTelephoneNumber:(NSString *)telephoneNumber andCorporateName:(NSString *)corporateName andPositionName:(NSString *)positionName;

+ (NSArray *)getOwnAccountAndPassword;
+ (int64_t)getOwnID;

+ (NSArray *)getActivitySignUpInfomation;

+ (NSArray *)getUsersInformation;

@end
