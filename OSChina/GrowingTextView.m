//
//  GrowingTextView.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "GrowingTextView.h"

@implementation GrowingTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    if (self = [super initWithPlaceholder:placeholder]) {
        self.font = [UIFont systemFontOfSize:16];
        self.scrollEnabled = YES;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.enablesReturnKeyAutomatically = YES;
        self.textContainerInset = UIEdgeInsetsMake(8.0, 3.5, 8.0, 0.0);
        self.maxNumberOfLines = 4;
    }
    
    return self;
}

// Code from apple developer forum - @Steve Krulewitz, @Mark Marszal, @Eric Silverberg
- (CGFloat)measureHeight {
    return self.contentSize.height;
}

- (NSUInteger)numberOfLines {
    return abs((self.contentSize.height - 16) / self.font.lineHeight);
}

@end
