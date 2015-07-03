//
//  MineViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCUser;

@interface MyInfoViewController : UITableViewController

- (instancetype)initWithUser:(OSCUser *)user;
- (instancetype)initWithUserId:(int64_t)userID;

@end
