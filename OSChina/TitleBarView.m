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
            
            

            
        }
        
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor colorWithHex:0xE1E1E1];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithHex:0x909090] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            
            button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, buttonHeight);
            button.tag = idx;
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.titleButtons addObject:button];
            [self addSubview:button];
            [self sendSubviewToBack:button];
        }];
        
        self.contentSize = CGSizeMake(frame.size.width, buttonHeight);
        self.showsHorizontalScrollIndicator = NO;
        
        UIButton *firstTitle = self.titleButtons.firstObject;
        [firstTitle setTitleColor:[UIColor colorWithHex:0x009000] forState:UIControlStateNormal];
        firstTitle.transform = CGAffineTransformMakeScale(1.15, 1.15);
    }
    
    return self;
}

#pragma mark --private 
- (void)onClick:(UIButton *)button {
    if (self.currentIndex != button.tag) {
        UIButton *preTitle = self.titleButtons[self.currentIndex];
        [preTitle setTitleColor:[UIColor colorWithHex:0x909090] forState:UIControlStateNormal];
        preTitle.transform = CGAffineTransformIdentity;
        
        [button setTitleColor:[UIColor colorWithHex:0x009000] forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.currentIndex = button.tag;
        
        self.titleButtonClicked(button.tag);
    }
}

@end
