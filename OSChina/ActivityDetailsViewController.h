//
//  ActivityDetailsViewController.h
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCActivity;

@interface ActivityDetailsViewController : UITableViewController

- (instancetype)initWithActivity:(OSCActivity *)activity;

@end
