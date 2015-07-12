//
//  OSCBlog.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBlog.h"

static NSString * const kID           = @"id";
static NSString * const kAuthor       = @"authorname";
static NSString * const kAuthorID     = @"authorid";
static NSString * const kTitle        = @"title";
static NSString * const kBody         = @"body";
static NSString * const kCommentCount = @"commentCount";
static NSString * const kPubDate      = @"pubDate";
static NSString * const kDocumentType = @"documentType";

@implementation OSCBlog

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _blogID       = [[[xml firstChildWithTag:kID] numberValue] longLongValue];
        _author       = [[xml firstChildWithTag:kAuthor] stringValue];
        _authorID     = [[[xml firstChildWithTag:kAuthorID] numberValue] longLongValue];
        _title        = [[xml firstChildWithTag:kTitle] stringValue];
        _body         = [[xml firstChildWithTag:kBody] stringValue];
        _commentCount = [[[xml firstChildWithTag:kCommentCount] numberValue] intValue];
        _pubDate      = [[xml firstChildWithTag:kPubDate] stringValue];
        _documentType = [[[xml firstChildWithTag:kDocumentType] numberValue] intValue];
    }
    
    return self;
}

@end
