//
//  OSCMessage.m
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCMessage.h"

static NSString * const kMessageID    = @"id";
static NSString * const kPortraitURL  = @"portrait";
static NSString * const kFriendID     = @"friendid";
static NSString * const kFriendName   = @"friendname";
static NSString * const kSenderID     = @"senderid";
static NSString * const kSenderName   = @"sender";
static NSString * const kContent      = @"content";
static NSString * const kMessageCount = @"messageCount";
static NSString * const kPubDate      = @"pubDate";

@interface OSCMessage()

@property (nonatomic, readwrite, assign) int64_t  messageID;
@property (nonatomic, readwrite, strong) NSURL    *portraitURL;
@property (nonatomic, readwrite, assign) int64_t  friendID;
@property (nonatomic, readwrite, copy  ) NSString *friendName;
@property (nonatomic, readwrite, assign) int64_t  senderID;
@property (nonatomic, readwrite, copy  ) NSString *senderName;
@property (nonatomic, readwrite, copy  ) NSString *content;
@property (nonatomic, readwrite, assign) int      messageCount;
@property (nonatomic, readwrite, copy  ) NSString *pubDate;

@end

@implementation OSCMessage

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    if (self = [super init]) {
        _messageID = [[[xml firstChildWithTag:kMessageID] numberValue] longLongValue];
        _portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:kPortraitURL] stringValue]];
        _friendID = [[[xml firstChildWithTag:kFriendID] numberValue] longLongValue];
        _friendName = [[xml firstChildWithTag:kFriendName] stringValue];
        _senderID = [[[xml firstChildWithTag:kSenderID] numberValue] longLongValue];
        _senderName = [[xml firstChildWithTag:kSenderName] stringValue];
        _content = [[xml firstChildWithTag:kContent] stringValue];
        _messageCount = [[[xml firstChildWithTag:kMessageCount] numberValue] intValue];
        _pubDate = [[xml firstChildWithTag:kPubDate] stringValue];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([self class] == [object class]) {
        return _messageID == ((OSCMessage *)object).messageID;
    }
    return NO;
}

@end
