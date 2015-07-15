//
//  GrowingTextView.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewWithPlaceholder.h"

@interface GrowingTextView : TextViewWithPlaceholder

@property (nonatomic, assign, readonly) NSUInteger numberOfLines;
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;

@end
