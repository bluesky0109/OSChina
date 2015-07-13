//
//  TitleBarView.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TitleBarView.h"
#import "UIColor+Util.h"

@interface TitleBarView()


@end


@implementation TitleBarView

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.currentIndex = 0;
        self.titleButtons = [NSMutableArray new];
        
        CGFloat buttonWidth = frame.size.width / titles.count;
        CGFloat buttonHeight = frame.size.height;
        
        NSUInteger i = 0;
        for (NSString *title in titles) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor colorWithHex:0xE1E1E1];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            
            button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, buttonHeight);
            button.tag = i++;
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
            [self addSubview:button];
            [self.titleButtons addObject:button];
        }
        
        self.contentSize = CGSizeMake(buttonWidth * i, buttonHeight);
        self.showsHorizontalScrollIndicator = NO;
        
        UIButton *firstTitle = self.titleButtons.firstObject;
        [firstTitle setTitleColor:[UIColor colorWithHex:0x008000] forState:UIControlStateNormal];
    }
    
    return self;
}

#pragma mark --private 
- (void)onClick:(UIButton *)button {
    if (self.currentIndex != button.tag) {
        UIButton *preTitle = self.titleButtons[self.currentIndex];
        [preTitle setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHex:0x008000] forState:UIControlStateNormal];
        
        self.currentIndex = button.tag;
        
        self.titleButtonClicked(button.tag);
    }
}

@end
