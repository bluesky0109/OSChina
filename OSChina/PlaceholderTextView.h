//
//  TextViewWithPlaceholder.h
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIFont *placeholderFont;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (void)checkShouldHidePlaceholder;

@end
