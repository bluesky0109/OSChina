//
//  HorizonalTableViewController.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizonalTableViewController : UITableViewController

@property (nonatomic, copy) void (^focusViewIndexChanged)(NSUInteger index);
@property (nonatomic, copy) void (^scrollView)(CGFloat offsetRatio);


- (instancetype)initWithViewControllers:(NSArray *)controllers;

- (void)scrollToViewAtIndex:(NSUInteger)index;


@end
