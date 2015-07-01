//
//  SwipeableViewController.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleBarView.h"
#import "HorizonalTableViewController.h"

@interface SwipeableViewController : UIViewController

@property (nonatomic, strong) HorizonalTableViewController *viewPager;
@property (nonatomic, strong) TitleBarView *titleBar;

- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers;

@end
