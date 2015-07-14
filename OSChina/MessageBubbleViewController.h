//
//  MessageBubbleViewController.h
//  OSChina
//
//  Created by sky on 15/7/13.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

@interface MessageBubbleViewController : OSCObjsViewController

@property (nonatomic, copy) void (^didScroll)();

- (instancetype)initWithUserID:(int64_t)userID andUserName:(NSString *)userName;

@end
