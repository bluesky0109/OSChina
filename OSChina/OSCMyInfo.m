//
//  OSCMyInfo.m
//  OSChina
//
//  Created by sky on 15/7/12.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCMyInfo.h"

@implementation OSCMyInfo

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _name               = [[[xml firstChildWithTag:@"name"] stringValue] copy];
        _portraitURL        = [NSURL URLWithString:[[xml firstChildWithTag:@"portrait"] stringValue]];
        _hometown           = [[[xml firstChildWithTag:@"from"] stringValue] copy];
        _developPlatform    = [[[xml firstChildWithTag:@"devplatform"] stringValue] copy];
        _expertise          = [[[xml firstChildWithTag:@"expertise"] stringValue] copy];
        _joinTime           = [[[xml firstChildWithTag:@"joinTime"] stringValue] copy];
        
        _gender             = [[[xml firstChildWithTag:@"gender"] numberValue] intValue];
        _favoriteCount      = [[[xml firstChildWithTag:@"favoritecount"] numberValue] intValue];
        _fansCount          = [[[xml firstChildWithTag:@"fans"] numberValue] intValue];
        _followersCount     = [[[xml firstChildWithTag:@"followers"] numberValue] intValue];
        _score              = [[[xml firstChildWithTag:@"score"] numberValue] intValue];
    }
    
    return self;
}


@end
