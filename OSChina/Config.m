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

@implementation Config

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:kAccount];
    [userDefaults synchronize];
    
    [SSKeychain setPassword:password forService:kService account:account];
}

+ (void)saveOwnID:(int64_t)userID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%lld",userID] forKey:kUserID];
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

+ (int64_t)getOwnID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:kUserID];
    
    if (userID) {
        return [userID longLongValue];
    }
    
    return 0;
}

@end
