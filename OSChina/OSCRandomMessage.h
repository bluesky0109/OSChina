//
//  OSCRandomMessage.h
//  OSChina
//
//  Created by sky on 15/7/10.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCRandomMessage : OSCBaseObject

@property (nonatomic, readonly, assign) int          randomType;
@property (nonatomic, readonly, assign) int64_t      randomMessageID;
@property (nonatomic, readonly, copy  ) NSString     *title;
@property (nonatomic, readonly, copy  ) NSString     *detail;
@property (nonatomic, readonly, copy  ) NSString     *author;
@property (nonatomic, readonly, assign) int64_t      authorID;
@property (nonatomic, readonly, strong) NSURL        *portraitURL;
@property (nonatomic, readonly, copy  ) NSString     *pubDate;
@property (nonatomic, readonly, assign) int          commentCount;
@property (nonatomic, readonly, strong) NSURL        *url;

@end
