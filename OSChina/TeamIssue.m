//
//  TeamIssue.m
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamIssue.h"

@implementation TeamIssue

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _issueID = [[[xml firstChildWithTag:@"id"] numberValue] intValue];
        _state = [[xml firstChildWithTag:@"state"] stringValue];
        _stateLevel = [[[xml firstChildWithTag:@"stateLevel"] numberValue] intValue];
        _priority = [[xml firstChildWithTag:@"priority"] stringValue];
        _gitPush = [[[xml firstChildWithTag:@"gitpush"] numberValue] boolValue];
        _source = [[xml firstChildWithTag:@"source"] stringValue];
        _catalogID = [[[xml firstChildWithTag:@"catalogid"] numberValue] intValue];
        _title = [[xml firstChildWithTag:@"title"] stringValue];
        _issueDescription = [[xml firstChildWithTag:@"description"] stringValue];
        _createTime = [[xml firstChildWithTag:@"createTime"] stringValue];
        _updateTime = [[xml firstChildWithTag:@"updateTime"] stringValue];
        _acceptTime = [[xml firstChildWithTag:@"acceptTime"] stringValue];
        _deadline = [[xml firstChildWithTag:@"deadlineTime"] stringValue];
        
        _replyCount = [[[xml firstChildWithTag:@"replyCount"] numberValue] intValue];
        _gitIssueURL = [NSURL URLWithString:[[xml firstChildWithTag:@"gitIssueUrl"] stringValue]];
        //_authority = [[TeamProjectAuthority alloc] initWithXML:[xml firstChildWithTag:@"authority"]];
        _project = [[TeamProject alloc] initWithXML:[xml firstChildWithTag:@"project"]];
        
        //ONOXMLElement *childIssuesXML = [xml firstChildWithTag:@"childIssues"];
        //_childIssuesCount = [[[childIssuesXML firstChildWithTag:@"totalCount"] numberValue] intValue];
        //_closedChildIssuesCount = [[[childIssuesXML firstChildWithTag:@"closedCount"] numberValue] intValue];
        
        _author = [[TeamMember alloc] initWithXML:[xml firstChildWithTag:@"author"]];
        _user = [[TeamMember alloc] initWithXML:[xml firstChildWithTag:@"toUser"]];
    }
    
    return self;
}


@end
