//
//  UIImageView+Util.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "UIImageView+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Util)

- (void)loadPortrait:(NSURL *)portraitURL {
    [self sd_setImageWithURL:portraitURL placeholderImage:nil options:0];
}

@end
