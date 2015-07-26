//
//  TeamCell.m
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamCell.h"
#import "Utils.h"

#define MARGIN 7

@implementation TeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setCornerRadius:3];
        self.backgroundColor = [UIColor colorWithHex:0x555555];
        UIView *selectedBackground = [UIView new];
        selectedBackground.backgroundColor = [UIColor colorWithHex:0x333333];
        self.selectedBackgroundView = selectedBackground;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += MARGIN;
    frame.size.width -= 2 * MARGIN;
    [super setFrame:frame];
}
@end
