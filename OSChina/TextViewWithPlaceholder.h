//
//  TextViewWithPlaceholder.h
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewWithPlaceholder : UITextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (void)setPlaceholder:(NSString *)placeholder;
- (void)checkShouldHidePlaceholder;

@end
