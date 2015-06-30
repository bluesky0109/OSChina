//
//  TitleBarView.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleBarView : UIScrollView

@property (nonatomic, copy) void (^titleButtonClicked)(NSUInteger index);

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;
- (void)focusTitleAtIndex:(NSUInteger)index;


@end
