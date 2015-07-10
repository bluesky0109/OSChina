//
//  BottomBarViewController.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingBar.h"
#import "OperationBar.h"

@class EmojiPageVC;

@interface BottomBarViewController : UIViewController

@property (nonatomic, strong) EditingBar         *editingBar;
@property (nonatomic, strong) OperationBar       *operationBar;
@property (nonatomic, strong) EmojiPageVC        *emojiPanelVC;
@property (nonatomic, strong) UIView             *emojiPanel;
@property (nonatomic, strong) NSLayoutConstraint *editingBarYContraint;
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightContraint;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;

@end
