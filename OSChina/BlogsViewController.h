//
//  BlogsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(NSUInteger, BlogsType)
{
    BlogsTypeLatest,
    BlogsTypeRecommended
};

@interface BlogsViewController : OSCObjsViewController

- (instancetype)initWithBlogsType:(BlogsType)type;
- (instancetype)initWithUserID:(int64_t)userID;

@end
