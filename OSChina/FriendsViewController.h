//
//  FriendsViewController.h
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

@interface FriendsViewController : OSCObjsViewController

- (instancetype)initWithUserID:(int64_t)userID andFriendsRelation:(int)relation;

@end
