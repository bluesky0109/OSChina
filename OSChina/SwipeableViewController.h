//
//  SwipeableViewController.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleBarView.h"

@interface SwipeableViewController : UIViewController

- (instancetype)initWithTitles:(NSArray *)titles andControllers:(NSArray *)controllers;

@end
