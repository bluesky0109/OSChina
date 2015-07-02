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
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
        firstTitle.titleLabel.font = [UIFont systemFontOfSize:16];
        [firstTitle setTitleColor:[UIColor colorWithHex:0x008000] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)focusTitleAtIndex:(NSUInteger)index ratio:(CGFloat)ration{
    UIButton *preTitle = self.titleButtons[self.currentIndex];
    [preTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.currentIndex = index;
    
    UIButton *currentTitle = self.titleButtons[self.currentIndex];
    [currentTitle setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    currentTitle.titleLabel.font = [UIFont systemFontOfSize:16];
}

#pragma mark --private 
- (void)onClick:(UIButton *)button {
    if (self.currentIndex != button.tag) {
        UIButton *preTitle = self.titleButtons[self.currentIndex];
        [preTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        preTitle.titleLabel.font = [UIFont systemFontOfSize:15];
        self.currentIndex = button.tag;
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.titleButtonClicked(button.tag);
    }
}

@end
