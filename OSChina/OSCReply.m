//
//  OSCReply.m
//  OSChina
//
//  Created by sky on 15/7/14.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCReply.h"

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

@end
