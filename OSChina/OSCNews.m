//
//  OSCNews.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCNews.h"
#import "Utils.h"
#import <UIKit/UIKit.h>

static NSString * const kID           = @"id";
static NSString * const kTitle        = @"title";
static NSString * const kBody         = @"body";
static NSString * const kCommentCount = @"commentCount";
static NSString * const kAuthor       = @"author";
static NSString * const kAuthorID     = @"authorid";
static NSString * const kPubDate      = @"pubDate";
static NSString * const kNewsType     = @"newstype";
static NSString * const kType         = @"type";
static NSString * const kURL          = @"url";
static NSString * const kEventURL     = @"eventurl";
static NSString * const kAttachment   = @"attachment";
static NSString * const kAuthorUID2   = @"authoruid2";

@implementation OSCNews

- (instancetype)initWithXML:(ONOXMLElement *)xml {
    if (self = [super init]) {
        _newsID                 = [[[xml firstChildWithTag:kID] numberValue] longLongValue];
        _title                  = [[xml firstChildWithTag:kTitle] stringValue];
        _body                   = [[xml firstChildWithTag:kBody] stringValue];
        _authorID               = [[[xml firstChildWithTag:kAuthorID] numberValue] longLongValue];
        _author                 = [[xml firstChildWithTag:kAuthor] stringValue];

        _commentCount           = [[[xml firstChildWithTag:kCommentCount] numberValue] intValue];
        _pubDate                = [[xml firstChildWithTag:kPubDate] stringValue];

        _url                    = [NSURL URLWithString:[[xml firstChildWithTag:@"url"] stringValue]];
        ONOXMLElement *newsType = [xml firstChildWithTag:kNewsType];
        _type                   = [[[newsType firstChildWithTag:kType] numberValue] intValue];
        _attachment             = [[newsType firstChildWithTag:kAttachment] stringValue];
        _authorUID2             = [[[newsType firstChildWithTag:kAuthorUID2] numberValue] longLongValue];
        _eventURL = [NSURL URLWithString:[[newsType firstChildWithTag:@"eventurl"] stringValue]];
    }
    return self;
}

- (NSAttributedString *)attributedTitle {
    if (!_attributedTitle) {
        if ([[Utils timeIntervalArrayFromString:_pubDate][kKeyDays] integerValue] == 0) {
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            textAttachment.image = [UIImage imageNamed:@"widget_taday"];
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            _attributedTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
            [_attributedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [_attributedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:_title]];
        } else {
            _attributedTitle = [[NSMutableAttributedString alloc] initWithString:_title];
        }
        
    }
    
    return _attributedTitle;
}

- (NSAttributedString *)attributedCommentCount {
    if (!_attributedCommentCount) {
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        textAttachment.image = [UIImage imageNamed:@"comment"];
        [textAttachment adjustY:-1];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        _attributedCommentCount = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
        [_attributedCommentCount appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [_attributedCommentCount appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", _commentCount]]];
    }
    
    return _attributedCommentCount;
}

- (BOOL)isEqual:(id)object {
    if ([self class] == [object class]) {
        return _newsID == ((OSCNews *)object).newsID;
    }
    return NO;
}

@end
