//
//  ActivityDetailsViewController.h
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCActivity;
@class OSCPostDetails;
@class ActivityDetailsWithBarViewController;

@interface ActivityDetailsViewController : UITableViewController

@property (nonatomic, weak) ActivityDetailsWithBarViewController *bottomBarVC;
@property (nonatomic, readonly, strong)OSCPostDetails *postDetails;

- (instancetype)initWithActivity:(OSCActivity *)activity;

@end
