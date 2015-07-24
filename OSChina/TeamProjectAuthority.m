//
//  TeamProjectAuthority.m
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamProjectAuthority.h"

static NSString * const kTRUE = @"true";

@implementation TeamProjectAuthority

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _authDelete = [[xml firstChildWithTag:@"detele"].stringValue isEqualToString:kTRUE];
        _authUpdateState = [[xml firstChildWithTag:@"updateState"].stringValue isEqualToString:kTRUE];
        _authUpdateAssignee = [[xml firstChildWithTag:@"updateAssinee"].stringValue isEqualToString:kTRUE];
        _authUpdateDeadline = [[xml firstChildWithTag:@"updateDeadlineTime"].stringValue isEqualToString:kTRUE];
        _authUpdatePriority = [[xml firstChildWithTag:@"updatePriority"].stringValue isEqualToString:kTRUE];
        _authUpdateLabels = [[xml firstChildWithTag:@"updateLabels"].stringValue isEqualToString:kTRUE];
    }
    
    return self;
}

@end
