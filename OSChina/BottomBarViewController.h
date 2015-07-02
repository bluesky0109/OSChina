//
//  BottomBarViewController.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BottomBar;

@interface BottomBarViewController : UIViewController

@property (nonatomic, strong) BottomBar *bottomBar;
@property (nonatomic, strong) NSLayoutConstraint *bottomContraint;

@end
