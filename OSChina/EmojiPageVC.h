//
//  EmojiPageVC.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextViewWithPlaceholder;

@interface EmojiPageVC : UIPageViewController

- (instancetype)initWithTextView:(TextViewWithPlaceholder *)textView;

@end
