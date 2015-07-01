//
//  OSCComment.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCComment : OSCBaseObject

@property (nonatomic, assign) int64_t        commentID;
@property (nonatomic, copy  ) NSURL          *portraitURL;
@property (nonatomic, copy  ) NSString       *author;
@property (nonatomic, assign) int64_t        authorID;
@property (nonatomic, copy  ) NSString       *content;
@property (nonatomic, copy  ) NSString       *pubDate;
@property (nonatomic, strong) NSMutableArray *replies;

@end
