//
//  OSCPost.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCPost : OSCBaseObject

@property (nonatomic, assign) int64_t  postID;
@property (nonatomic, copy  ) NSURL    *portraitURL;
@property (nonatomic, copy  ) NSString *author;
@property (nonatomic, assign) int64_t  authorID;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *body;
@property (nonatomic, assign) int      replyCount;
@property (nonatomic, assign) int      viewCount;
@property (nonatomic, copy  ) NSString *pubDate;

@end
