//
//  NewsViewController.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(int, NewsListType)
{
    NewsListTypeAllType = 0,
    NewsListTypeNews,
    NewsListTypeSynthesis,
    NewsListTypeSoftwareRenew
};

@interface NewsViewController : OSCObjsViewController

- (instancetype)initWithNewsListType:(NewsListType)type;

@end
