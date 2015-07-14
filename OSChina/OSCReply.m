//
//  OSCReply.m
//  OSChina
//
//  Created by sky on 15/7/14.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCReply.h"

@interface OSCReply()

@property (nonatomic, readwrite, copy) NSString *author;
@property (nonatomic, readwrite, copy) NSString *pubDate;
@property (nonatomic, readwrite, copy) NSString *content;

@end

@implementation OSCReply

- (instancetype)initWithXML:(ONOXMLElement *)xml {
    self = [super init];
    if (self) {
        _author = [[xml firstChildWithTag:@"rauthor"] stringValue];
        _pubDate = [[xml firstChildWithTag:@"rpubDate"] stringValue];
        _content = [[xml firstChildWithTag:@"rcontent"] stringValue];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    OSCReply *replyCopy = [OSCReply allocWithZone:zone];
    
    replyCopy.author = _author;
    replyCopy.pubDate = _pubDate;
    replyCopy.content = _content;
    
    return replyCopy;
}

@end
