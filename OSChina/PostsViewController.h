//
//  PostsViewController.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(NSUInteger, PostsType)
{
    PostsTypeQA = 1,
    PostsTypeShare,
    PostsTypeSynthesis,
    PostsTypeCaree,
    PostsTypeSiteManager
};


@interface PostsViewController : OSCObjsViewController

- (instancetype)initWithType:(PostsType)type;

@end
