//
//  DetailsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//


#import "BottomBarViewController.h"

typedef NS_ENUM(int, DetailsType)
{
    DetailsTypeNews,
    DetailsTypeBlog,
    DetailsTypeSoftware
};

typedef NS_ENUM(int, FavoriteType)
{
    FavoriteTypeSoftware,
    FavoriteTypeTopic,
    FavoriteTypeBlog,
    FavoriteTypeNews,
    FavoriteTypeCode
};

@class OSCNews;
@class OSCBlog;
@class OSCPost;
@class OSCSoftware;

@interface DetailsViewController : BottomBarViewController

- (instancetype)initWithNews:(OSCNews *)news;
- (instancetype)initWithBlog:(OSCBlog *)blog;
- (instancetype)initWithPost:(OSCPost *)post;
- (instancetype)initWithSoftware:(OSCSoftware *)software;

@end
