//
//  BottomBarViewController.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BottomBar;
@class EmojiPageVC;

@interface BottomBarViewController : UIViewController

@property (nonatomic, strong) BottomBar *bottomBar;
@property (nonatomic, strong) EmojiPageVC *emojiPanelVC;
@property (nonatomic, strong) UIView *emojiPanel;
@property (nonatomic, strong) NSLayoutConstraint *bottomBarYContraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomBarHeightContraint;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;

@end
