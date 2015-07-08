//
//  TabBarCenterButton.h
//  OSChina
//
//  Created by sky on 15/7/8.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarCenterButton : UIButton

@property (nonatomic, assign, readonly) BOOL pressed;

- (instancetype)initWithTabBar:(UITabBar *)tabBar;


@end
