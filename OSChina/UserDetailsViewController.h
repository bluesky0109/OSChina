//
//  UserDetailsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsViewController.h"

@interface UserDetailsViewController : EventsViewController

- (instancetype)initWithUserID:(int64_t)userID;
- (instancetype)initWithUserName:(NSString *)userName;

@end
