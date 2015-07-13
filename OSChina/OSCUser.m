//
//  OSCUser.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCUser.h"

static NSString * const kID               = @"uid";
static NSString * const kUserID           = @"userid";
static NSString * const kLocation         = @"location";
static NSString * const kFrom             = @"from";
static NSString * const kName             = @"name";
static NSString * const kFollowers        = @"followers";
static NSString * const kFans             = @"fans";
static NSString * const kScore            = @"score";
static NSString * const kRelationship     = @"relation";
static NSString * const kPortrait         = @"portrait";
static NSString * const kDevlopPlatform   = @"devplatform";
static NSString * const kExpertise        = @"expertise";
static NSString * const kJoinTime         = @"jointime";
static NSString * const kLatestOnlineTime = @"latestonline";

@interface OSCUser()

@end

@implementation OSCUser

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (!self) {return nil;}
    
    // 有些API返回用<id>，有些地方用<userid>，这样写是为了简化处理
    _userID = [[[xml firstChildWithTag:kID] numberValue] longLongValue] | [[[xml firstChildWithTag:kUserID] numberValue] longLongValue];
    _location = [[[xml firstChildWithTag:kLocation] stringValue] copy];
    if (!_location) {
        _location = [[[xml firstChildWithTag:kFrom] stringValue] copy];
    }
    
    _name = [[[xml firstChildWithTag:kName] stringValue] copy];
    _followersCount = [[[xml firstChildWithTag:kFollowers] numberValue] intValue];
    _fansCount = [[[xml firstChildWithTag:kFans] numberValue] intValue];
    _score = [[[xml firstChildWithTag:kScore] numberValue] intValue];
    _relationship = [[[xml firstChildWithTag:kRelationship] numberValue] intValue];
    _portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:kPortrait] stringValue]];
    _developPlatform = [[[xml firstChildWithTag:kDevlopPlatform] stringValue] copy];
    _expertise = [[[xml firstChildWithTag:kExpertise] stringValue] copy];
    _joinTime = [[[xml firstChildWithTag:kJoinTime] stringValue] copy];
    _latestOnlineTime = [[[xml firstChildWithTag:@"latestonline"] stringValue] copy];
    
    return self;
}

@end
