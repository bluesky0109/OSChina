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

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setLayout];
    }
    
    return self;
}

- (void)setLayout {
    
    UIButton *modeSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [modeSwitchButton setImage:[UIImage imageNamed:@"button_keyboard_normal"] forState:UIControlStateNormal];
    
    UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiButton setImage:[UIImage imageNamed:@"button_emoji_normal"] forState:UIControlStateNormal];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setImage:[UIImage imageNamed:@"button_comment_normal"] forState:UIControlStateNormal];
    
    _editView = [GrowingTextView new];
    [_editView setCornerRadius:5.0];
    [_editView setBorderWidth:1.0f andColor:[UIColor colorWithHex:0xC8C8CD].CGColor];
    _editView.backgroundColor = [UIColor colorWithHex:0xF5FAFA];
    
    [self addSubview:_editView];
    [self addSubview:modeSwitchButton];
    [self addSubview:emojiButton];
    [self addSubview:commentButton];
    
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(modeSwitchButton,emojiButton,commentButton,_editView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[modeSwitchButton]-5-[_editView]-5-[emojiButton][commentButton]-5-|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[modeSwitchButton]-3-|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[emojiButton]-3-|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[commentButton]-3-|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_editView]-5-|" options:0 metrics:nil views:viewsDict]];
}

#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
}

@end
