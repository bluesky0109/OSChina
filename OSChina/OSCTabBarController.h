//
//  OSCTabBarController.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSCTabBarController : UITabBarController

@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, copy) void (^presentLeftMenuViewController)();

@end
