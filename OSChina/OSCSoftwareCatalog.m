//
//  OSCSoftwareCatalog.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCSoftwareCatalog.h"

static NSString * const kName = @"name";
static NSString * const kTag = @"tag";

@interface OSCSoftwareCatalog()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, assign, readwrite) int tag;

@end

@implementation OSCSoftwareCatalog

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    if (self = [super init]) {
        _name = [[xml firstChildWithTag:kName] stringValue];
        _tag = [[[xml firstChildWithTag:kTag] numberValue] intValue];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    return NO;
}

@end
