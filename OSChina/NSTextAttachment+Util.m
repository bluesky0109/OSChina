//
//  NSTextAttachment+Util.m
//  OSChina
//
//  Created by sky on 15/7/23.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "NSTextAttachment+Util.h"

@implementation NSTextAttachment (Util)

- (void)adjustY:(CGFloat)y {
    self.bounds = CGRectMake(0, y, self.image.size.width, self.image.size.height);
}

@end
