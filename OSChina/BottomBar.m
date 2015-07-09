//
//  BottomBar.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "BottomBar.h"
#import "GrowingTextView.h"
#import "Utils.h"

@interface BottomBar()<UITextViewDelegate>

@end

@implementation BottomBar

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton {
    self = [super init];
    if(self) {
        self.backgroundColor = [UIColor grayColor];
        [self setLayoutWithModeSwitchButton:hasAModeSwitchButton];
    }
    
    return self;
}

- (void)setLayoutWithModeSwitchButton:(BOOL)hasAModeSwitchButton {
    
    _modeSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_modeSwitchButton setImage:[UIImage imageNamed:@"button_keyboard_normal"] forState:UIControlStateNormal];
    
    _inputViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inputViewButton setImage:[UIImage imageNamed:@"button_emoji_normal"] forState:UIControlStateNormal];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setImage:[UIImage imageNamed:@"button_comment_normal"] forState:UIControlStateNormal];
    
    _editView = [GrowingTextView new];
    [_editView setCornerRadius:5.0];
    [_editView setBorderWidth:1.0f andColor:[UIColor colorWithHex:0xC8C8CD].CGColor];
    _editView.backgroundColor = [UIColor colorWithHex:0xF5FAFA];
    
    [self addSubview:_editView];
    [self addSubview:_modeSwitchButton];
    [self addSubview:_inputViewButton];
    [self addSubview:commentButton];
    
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_modeSwitchButton,_inputViewButton,commentButton,_editView);
    
    if (hasAModeSwitchButton) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_modeSwitchButton]-5-[_editView]-5-[_inputViewButton][commentButton]-5-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_modeSwitchButton]-3-|" options:0 metrics:nil views:views]];
    } else {
        [_modeSwitchButton removeFromSuperview];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_editView]-5-[_inputViewButton][commentButton]-5-|" options:0 metrics:nil views:views]];
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_inputViewButton]-3-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[commentButton]-3-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_editView]-5-|" options:0 metrics:nil views:views]];
}

#pragma mark - 键盘和表情面板切换

#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
}

@end
