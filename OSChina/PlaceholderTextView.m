//
//  TextViewWithPlaceholder.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "PlaceholderTextView.h"
#import <ReactiveCocoa.h>

@interface PlaceholderTextView()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation PlaceholderTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    self = [super init];
    if (self) {
        [self setUpPlaceholderLabel:placeholder];
    }
    
    return self;
}

- (void)setUpPlaceholderLabel:(NSString *)placeholder {
    _placeholderLabel = [UILabel new];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.text = placeholder;
    [self addSubview:_placeholderLabel];

    _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_placeholderLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_placeholderLabel]-6-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_placeholderLabel]"   options:0 metrics:nil views:views]];
    
    RAC(_placeholderLabel, hidden) = [self.rac_textSignal map:^(NSString *text) {
        return @(text.length > 0);
    }];
}

- (void)checkShouldHidePlaceholder {
    _placeholderLabel.hidden = [self hasText];
}

#pragma mark - getter and setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholderLabel.text = placeholder;
}

- (NSString *)placeholder {
    return _placeholderLabel.text;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderLabel.font = placeholderFont;
}

- (UIFont *)placeholderFont {
    return _placeholderLabel.font;
}

@end
