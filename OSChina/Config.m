//
//  Config.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "Config.h"
#import <SSKeychain.h>

NSString * const kService = @"OSChina";
NSString * const kAccount = @"account";
NSString * const kUserID  = @"userID";

NSString * const kUserName      = @"name";
NSString * const kPortrait      = @"portrait";
NSString * const kUserScore     = @"score";
NSString * const kFavoriteCount = @"favoritecount";
NSString * const kFanCount      = @"fans";
NSString * const kFollowerCount = @"followers";

NSString * const kJointime        = @"jointime";
NSString * const kDevelopPlatform = @"devplatform";
NSString * const kExpertise       = @"expertise";
NSString * const kHometown        = @"from";

NSString * const kName        = @"name";
NSString * const kSex         = @"sex";
NSString * const kPhoneNumber = @"phoneNumber";
NSString * const kCorporation = @"corporation";
NSString * const kPosition    = @"position";

@implementation Config

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:kAccount];
    [userDefaults synchronize];
    
    [SSKeychain setPassword:password forService:kService account:account];
}

+ (void)saveOwnID:(int64_t)userID userName:(NSString *)userName score:(int)score favoriteCount:(int)favoriteCount fansCount:(int)fanCount andFollowerCount:(int)followerCount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(userID) forKey:kUserID];
    [userDefaults setObject:userName forKey:kUserName];
    [userDefaults setObject:@(score) forKey:kUserScore];
    [userDefaults setObject:@(favoriteCount) forKey:kFavoriteCount];
    [userDefaults setObject:@(fanCount) forKey:kFanCount];
    [userDefaults setObject:@(followerCount) forKey:kFollowerCount];

    [userDefaults synchronize];
}

+ (void)savePortrait:(UIImage *)portrait {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:UIImagePNGRepresentation(portrait) forKey:kPortrait];
    
    [userDefaults synchronize];
}

+ (void)saveName:(NSString *)actorName sex:(NSInteger)sex phoneNumber:(NSString *)phoneNumber corporation:(NSString *)corporation andPosition:(NSString *)position {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:actorName forKey:kName];
    [userDefaults setObject:@(sex) forKey:kSex];
    [userDefaults setObject:phoneNumber forKey:kPhoneNumber];
    [userDefaults setObject:corporation forKey:kCorporation];
    [userDefaults setObject:position forKey:kPosition];
    
    [userDefaults synchronize];
}

+ (NSArray *)getOwnAccountAndPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefaults objectForKey:kAccount];
    NSString *password = [SSKeychain passwordForService:kService account:account];
    
    if (account) {
        return @[account,password];
    }
    
    return nil;
}

+ (NSArray *)getActivitySignUpInfomation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *name = [userDefaults objectForKey:kName];
    NSNumber *sex = [userDefaults objectForKey:kSex];
    NSString *phoneNumber = [userDefaults objectForKey:kPhoneNumber];
    NSString *corporation = [userDefaults objectForKey:kCorporation];
    NSString *position = [userDefaults objectForKey:kPosition];
    if (name) {
        return @[name, sex, phoneNumber, corporation, position];
    }
    return nil;
}

+ (int64_t)getOwnID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userID = [userDefaults objectForKey:kUserID];
    
    if (userID) {
        return [userID longLongValue];
    }
    
    return 0;
}

+ (NSArray *)getUsersInformation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:kUserName];
    NSNumber *score = [userDefaults objectForKey:kUserScore];
    NSNumber *favoriteCount = [userDefaults objectForKey:kFavoriteCount];
    NSNumber *fans = [userDefaults objectForKey:kFanCount];
    NSNumber *follower = [userDefaults objectForKey:kFollowerCount];
    NSNumber *userID = [userDefaults objectForKey:kUserID];
    if (userName) {
        return @[userName, score, favoriteCount, follower, fans, userID];
    }
    return @[@"点击头像登陆", @(0), @(0), @(0), @(0), @(0)];
}

+ (UIImage *)getImage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UIImage *portrait = [UIImage imageWithData:[userDefaults objectForKey:kPortrait]];
    
    return portrait;
}

@end
