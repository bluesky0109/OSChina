//
//  OSCReply.h
//  OSChina
//
//  Created by sky on 15/7/14.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCReply : OSCBaseObject

@property (nonatomic, readonly, copy) NSString *author;
@property (nonatomic, readonly, copy) NSString *pubDate;
@property (nonatomic, readonly, copy) NSString *content;

@end
