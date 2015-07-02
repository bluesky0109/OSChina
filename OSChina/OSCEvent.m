//
//  OSCEvent.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCEvent.h"

static NSString * const kID            = @"uid";
static NSString * const kMessage       = @"message";
static NSString * const kTweetImg      = @"tweetimage";

static NSString * const kAuthorID      = @"authorid";
static NSString * const kAuthor        = @"author";
static NSString * const kPortrait      = @"portrait";

static NSString * const kCatalog       = @"catalog";
static NSString * const kAppClient     = @"appclient";
static NSString * const kCommentCount  = @"commentCount";
static NSString * const kPubDate       = @"pubDate";

static NSString * const kObjectType    = @"objecttype";
static NSString * const kObjectTitle   = @"objecttitle";
static NSString * const kObjectID      = @"objectid";
static NSString * const kObjectName    = @"objectname";
static NSString * const kObjectBody    = @"objectbody";
static NSString * const kObjectCatalog = @"objectcatalog";


@implementation OSCEvent

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    if (self = [super init]) {
        _eventID = [[[xml firstChildWithTag:kID] numberValue] longLongValue];
        _message = [[xml firstChildWithTag:kMessage] stringValue];
        _tweetImg = [NSURL URLWithString:[[xml firstChildWithTag:kTweetImg] stringValue]];
        
        _authorID = [[[xml firstChildWithTag:kAuthorID] numberValue] longLongValue];
        _author = [[xml firstChildWithTag:kAuthor] stringValue];
        _portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:kPortrait] stringValue]];
        
        _catalog = [[[xml firstChildWithTag:kCatalog] numberValue] intValue];
        _appclient = [[[xml firstChildWithTag:kAppClient] numberValue] intValue];
        _commentCount = [[[xml firstChildWithTag:kCommentCount] numberValue] intValue];
        _pubDate = [[xml firstChildWithTag:kPubDate] stringValue];
        
        _objectID = [[[xml firstChildWithTag:kObjectID] numberValue] longLongValue];
        _objectType = [[[xml firstChildWithTag:kObjectType] numberValue] intValue];
        _objectCatalog = [[[xml firstChildWithTag:kObjectCatalog] numberValue] intValue];
        _objectTitle = [[xml firstChildWithTag:kObjectTitle] stringValue];
        NSString *objectName = [[xml firstChildWithTag:kObjectName] stringValue];
        NSString *objectBody = [[xml firstChildWithTag:kObjectBody] stringValue];
        _objectReply = @[objectName, objectBody];
    }
    
    return self;
}


@end
