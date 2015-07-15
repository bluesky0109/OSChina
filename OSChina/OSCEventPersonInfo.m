//
//  OSCEventPersonInfo.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCEventPersonInfo.h"

static NSString * const kUserID = @"uid";
static NSString * const kUserName = @"name";
static NSString * const kPortrait = @"portrait";
static NSString * const kCompany = @"company";
static NSString * const kJob = @"job";

@implementation OSCEventPersonInfo

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _userID = [[[xml firstChildWithTag:kUserID] numberValue] intValue];
    _userName = [[[xml firstChildWithTag:kUserName] stringValue] copy];
    _portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:kPortrait] stringValue]];
    _company = [[[xml firstChildWithTag:kCompany] stringValue] copy];
    _job = [[[xml firstChildWithTag:kJob] stringValue] copy];
    
    return self;
}

@end
