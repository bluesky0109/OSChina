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

@property (nonatomic, strong) UITextView *editView;
@property (nonatomic, strong) UIBarButtonItem *modeSwitchButton;

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
    UIView *accessoryView = [UIView new];
    
    _modeSwitchButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"button_keyboard_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self action:nil];
    
    _editView = [GrowingTextView new];
    [_editView setBorderWidth:1.0f andColor:[[UIColor darkTextColor] CGColor]];
    _editView.text = @"1232432543";
    
    UIBarButtonItem *editView = [[UIBarButtonItem alloc] initWithCustomView:_editView];
    
    UIBarButtonItem *emojiButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"button_emoji_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                    style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"button_comment_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                   style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self setItems:@[_modeSwitchButton, editView, emojiButton, sendButton] animated:YES];
}

#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
}

@end
