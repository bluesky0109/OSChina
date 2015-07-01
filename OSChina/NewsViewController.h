//
//  NewsViewController.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(int, NewsType)
{
    NewsTypeAllType = 0,
    NewsTypeNews,
    NewsTypeSynthesis,
    NewsTypeSoftwareRenew
};

@interface NewsViewController : OSCObjsViewController

- (instancetype)initWithNewsType:(NewsType)type;

@end
