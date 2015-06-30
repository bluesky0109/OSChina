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
static NSString * const kAnswerCount = @"answerCount";
static NSString * const kViewCount   = @"viewCount";
static NSString * const kPubDate     = @"pubDate";

@implementation OSCPost

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        self.postID = [[[xml firstChildWithTag:kID] numberValue] longLongValue];
        self.portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:kPortrait] stringValue]];
        self.author = [[xml firstChildWithTag:kAuthor] stringValue];
        self.authorID = [[[xml firstChildWithTag:kAuthorID] numberValue] longLongValue];
        self.title = [[xml firstChildWithTag:kTitle] stringValue];
        self.answerCount = [[[xml firstChildWithTag:kAnswerCount] numberValue] intValue];
        self.viewCount = [[[xml firstChildWithTag:kViewCount] numberValue] intValue];
        self.pubDate = [[xml firstChildWithTag:kPubDate] stringValue];
    }
    
    return self;
}

@end
