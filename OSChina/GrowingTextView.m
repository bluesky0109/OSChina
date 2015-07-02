//
//  GrowingTextView.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "GrowingTextView.h"

@implementation GrowingTextView

- (instancetype)init {
    if (self = [super init]) {
        self.font = [UIFont systemFontOfSize:14.0];
        self.scrollEnabled = YES;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

// Code from apple developer forum - @Steve Krulewitz, @Mark Marszal, @Eric Silverberg
- (CGFloat)measureHeight {
    return self.contentSize.height;
}

@end
