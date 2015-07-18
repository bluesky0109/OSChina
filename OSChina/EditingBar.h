//
//  BottomBar.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextView.h"

@interface EditingBar : UIToolbar

@property (nonatomic, copy) void (^sendContent)(NSString *content);

@property (nonatomic, strong) GrowingTextView *editView;
@property (nonatomic, strong) UIButton        *modeSwitchButton;
@property (nonatomic, strong) UIButton        *inputViewButton;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;

@end
