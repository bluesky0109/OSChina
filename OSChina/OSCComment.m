//
//  OSCComment.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCComment.h"

static NSString * const kID       = @"id";
static NSString * const kPortrait = @"portrait";
static NSString * const kAuthor   = @"author";
static NSString * const kAuthorID = @"authorid";
static NSString * const kContent  = @"content";
static NSString * const kPubDate  = @"pubDate";
static NSString * const kReplies  = @"replies";
static NSString * const kReply    = @"reply";
static NSString * const kRauthor  = @"rauthor";
static NSString * const kRContent = @"rcontent";

@implementation OSCComment

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    if (self = [super init]) {
        self.commentID = [[[xml firstChildWithTag:kID] numberValue] longLongValue];
        self.authorID = [[[xml firstChildWithTag:kAuthorID] numberValue] longLongValue];
        
        self.portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:kPortrait] stringValue]];
        self.author = [[xml firstChildWithTag:kAuthor] stringValue];
        
        self.content = [[xml firstChildWithTag:kContent] stringValue];
        self.pubDate = [[xml firstChildWithTag:kPubDate] stringValue];
        
        self.replies = [NSMutableArray new];
        NSArray *repliesXML = [[xml firstChildWithTag:kReplies] childrenWithTag:kReply];
        for (ONOXMLElement *replyXML in repliesXML) {
            NSString *rauthor = [[replyXML firstChildWithTag:kRauthor] stringValue];
            NSString *rcontent = [[replyXML firstChildWithTag:kRContent] stringValue];
            [self.replies addObject:@[rauthor, rcontent]];
        }
    }
    
    return self;
}


@end
