//
//  OSCBlog.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBlog.h"
#import "Utils.h"
#import <UIKit/UIKit.h>

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

- (NSMutableAttributedString *)attributedTitle {
    if (!_attributedTitle) {
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        if (_documentType == 0) {
            textAttachment.image = [UIImage imageNamed:@"widget_repost"];
        } else {
            textAttachment.image = [UIImage imageNamed:@"widget-original"];
        }
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        _attributedTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
        [_attributedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [_attributedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:_title]];
    }
    
    return _attributedTitle;
}

- (NSMutableAttributedString *)attributedCommentCount {
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
        return _blogID == ((OSCBlog *)object).blogID;
    }
    return NO;
}

@end
