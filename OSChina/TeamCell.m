//
//  TeamCell.m
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamCell.h"

@implementation TeamCell

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 8;
    frame.size.width -= 2 * 8;
    [super setFrame:frame];
}
@end
