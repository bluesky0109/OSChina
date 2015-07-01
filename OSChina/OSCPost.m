//
//  OSCPost.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCPost.h"

static NSString * const kID          = @"id";
static NSString * const kPortrait    = @"portrait";
static NSString * const kAuthor      = @"author";
static NSString * const kAuthorID    = @"authorid";
static NSString * const kTitle       = @"title";
static NSString * const kReplyCount  = @"answerCount";
static NSString * const kViewCount   = @"viewCount";
static NSString * const kPubDate     = @"pubDate";

@implementation OSCPost

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _postID      = [[[xml firstChildWithTag:kID] numberValue] longLongValue];
        _portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:kPortrait] stringValue]];
        _author      = [[xml firstChildWithTag:kAuthor] stringValue];
        _authorID    = [[[xml firstChildWithTag:kAuthorID] numberValue] longLongValue];
        _title       = [[xml firstChildWithTag:kTitle] stringValue];
        _replyCount  = [[[xml firstChildWithTag:kReplyCount] numberValue] intValue];
        _viewCount   = [[[xml firstChildWithTag:kViewCount] numberValue] intValue];
        _pubDate     = [[xml firstChildWithTag:kPubDate] stringValue];
    }
    
    return self;
}

@end
