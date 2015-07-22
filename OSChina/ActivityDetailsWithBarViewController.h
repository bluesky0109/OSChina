//
//  ActivityDetailsWithBarViewController.h
//  OSChina
//
//  Created by sky on 15/7/17.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "BottomBarViewController.h"

@class OSCActivity;

@interface ActivityDetailsWithBarViewController : BottomBarViewController

@property (nonatomic, copy) void (^didScroll)();

- (instancetype)initWithActivityID:(int64_t)activityID;

@end
