//
//  BottomBar.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomBar : UIToolbar

@property (nonatomic, copy) void (^sendContent)(NSString *content);

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton   *sendButton;
@property (nonatomic, strong) UIButton   *switchModeButton;

@end
