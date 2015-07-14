//
//  OSCReference.m
//  OSChina
//
//  Created by sky on 15/7/14.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCReference.h"

@implementation OSCReference

- (instancetype)initWithXML:(ONOXMLElement *)xml {
    self = [super init];
    if (self) {
        _title = [[xml firstChildWithTag:@"refertitle"] stringValue];
        _body  = [[xml firstChildWithTag:@"referbody"] stringValue];
    }
    
    return self;
}

@end
