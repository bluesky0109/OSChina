//
//  BubbleChatViewController.h
//  OSChina
//
//  Created by sky on 15/7/14.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "BottomBarViewController.h"

@interface BubbleChatViewController : BottomBarViewController

- (instancetype)initWithUserID:(int64_t)userID andUserName:(NSString *)userName;

@end
