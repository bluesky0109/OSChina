//
//  OSCEvent.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCEvent : OSCBaseObject

// 主要信息
@property (nonatomic, assign) int64_t  eventID;
@property (nonatomic, copy  ) NSString *message;
@property (nonatomic, copy  ) NSURL    *tweetImg;

// 作者相关
@property (nonatomic, assign) int64_t  authorID;
@property (nonatomic, copy  ) NSString *author;
@property (nonatomic, copy  ) NSURL    *portraitURL;

// 其他信息
@property (nonatomic, copy  ) NSString *pubDate;
@property (nonatomic, assign) int      appclient;
@property (nonatomic, assign) int      catalog;
@property (nonatomic, assign) int      commentCount;

// 评论、回复相关
@property (nonatomic, assign) int64_t  objectID;
@property (nonatomic, assign) int      objectType;
@property (nonatomic, assign) int      objectCatalog;
@property (nonatomic, copy  ) NSString *objectTitle;
@property (nonatomic, strong) NSArray  *objectReply;

@property (nonatomic, assign) BOOL hasAnImage;
@property (nonatomic, assign) BOOL hasReference;
@property (nonatomic, assign) BOOL shouldShowClientOrCommentCount;

@property (nonatomic, strong, readonly) NSMutableAttributedString *actionStr;
@property (nonatomic, strong) NSMutableAttributedString *attributedCommentCount;


@end
