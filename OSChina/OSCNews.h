//
//  OSCNews.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

typedef NS_ENUM(int, NewsType)
{
    NewsTypeStandardNews,
    NewsTypeSoftWare,
    NewsTypeQA,
    NewsTypeBlog
};

@interface OSCNews : OSCBaseObject

@property (nonatomic, assign) int64_t  newsID;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *body;
@property (nonatomic, assign) int      commentCount;
@property (nonatomic, copy  ) NSString *author;
@property (nonatomic, assign) int64_t  authorID;
@property (nonatomic, assign) NewsType type;
@property (nonatomic, copy  ) NSString *pubDate;
@property (nonatomic, copy  ) NSString *attachment;
@property (nonatomic, assign) int64_t  authorUID2;

@end
