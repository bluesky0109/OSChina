//
//  UserDetailsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCUser;

@interface UserDetailsViewController : UITableViewController

- (instancetype)initWithUser:(OSCUser *)user;
- (instancetype)initWithUserID:(int64_t)userID;
- (instancetype)initWithUserName:(NSString *)userName;

@end
