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

NSString * const kUserName          = @"name";
NSString * const kPortrait = @"portrait";
NSString * const kUserScore         = @"score";
NSString * const kUserFavoriteCount = @"favoritecount";
NSString * const kUserFans          = @"fans";
NSString * const kUserFollowers     = @"followers";

NSString * const kJointime        = @"jointime";
NSString * const kDevelopPlatform = @"devplatform";
NSString * const kExpertise       = @"expertise";
NSString * const kHometown        = @"from";

NSString * const kActorName       = @"Actor";
NSString * const kSex             = @"Sex";
NSString * const kTelephoneNumber = @"TelephoneNumber";
NSString * const kCorporateName   = @"CorporateName";
NSString * const kPositionName    = @"PositionName";

@implementation Config

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:kAccount];
    [userDefaults synchronize];
    
    [SSKeychain setPassword:password forService:kService account:account];
}

+ (void)saveOwnUserName:(NSString *)userName andPortrait:(NSData *)portrait andUserScore:(int)score andUserFavoriteCount:(int)favoriteCount andUserFans:(int)fans andUserFollower:(int)follower andOwnID:(int64_t)userID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:kUserName];
    [userDefaults setObject:portrait forKey:kPortrait];
    [userDefaults setObject:@(score) forKey:kUserScore];
    [userDefaults setObject:@(favoriteCount) forKey:kUserFavoriteCount];
    [userDefaults setObject:@(fans) forKey:kUserFans];
    [userDefaults setObject:@(follower) forKey:kUserFollowers];
    [userDefaults setObject:@(userID) forKey:kUserID];
    [userDefaults synchronize];
}

+ (void)saveActivityActorName:(NSString *)actorName andSex:(NSInteger)sex andTelephoneNumber:(NSString *)telephoneNumber andCorporateName:(NSString *)corporateName andPositionName:(NSString *)positionName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:actorName forKey:kActorName];
    [userDefaults setObject:@(sex) forKey:kSex];
    [userDefaults setObject:telephoneNumber forKey:kTelephoneNumber];
    [userDefaults setObject:corporateName forKey:kCorporateName];
    [userDefaults setObject:positionName forKey:kPositionName];
    
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

    NSString *actorName = [userDefaults objectForKey:kActorName];
    NSNumber *sex = [userDefaults objectForKey:kSex];
    NSString *telephoneNumber = [userDefaults objectForKey:kTelephoneNumber];
    NSString *corporateName = [userDefaults objectForKey:kCorporateName];
    NSString *positionName = [userDefaults objectForKey:kPositionName];
    if (actorName) {
        return @[actorName, sex, telephoneNumber, corporateName, positionName];
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
    NSData *portrait = [userDefaults objectForKey:kPortrait];
    NSNumber *score = [userDefaults objectForKey:kUserScore];
    NSNumber *favoriteCount = [userDefaults objectForKey:kUserFavoriteCount];
    NSNumber *fans = [userDefaults objectForKey:kUserFans];
    NSNumber *follower = [userDefaults objectForKey:kUserFollowers];
    NSNumber *userID = [userDefaults objectForKey:kUserID];
    if (userName) {
        return @[userName, score, favoriteCount, follower, fans, userID];
    }
    return @[userName, score, favoriteCount, follower, fans, userID];
}

@end
