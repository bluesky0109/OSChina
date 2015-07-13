//
//  EventsViewController.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

@interface EventsViewController : OSCObjsViewController

- (instancetype)initWithCatalog:(int)catalog;
- (instancetype)initWithUserID:(int64_t)userID;
- (instancetype)initWithUserName:(NSString *)userName;

@end
