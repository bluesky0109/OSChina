//
//  OperationBar.m
//  OSChina
//
//  Created by sky on 15/7/10.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OperationBar.h"
#import <ReactiveCocoa.h>

@implementation OperationBar

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        [self setLayout];
        [self addBorder];
    }
    
    return self;
}


- (void)setLayout
{
    NSMutableArray *items = [NSMutableArray new];
    NSArray *images    = @[@"editingbar", @"toolbar-showComments", @"toolbar-star", @"toolbar-share", @"toolbar-report"];
    NSArray *selectors = @[@"switchMode:", @"showComments:", @"toggleStar:", @"share:", @"report:"];
    
    for (int i = 0; i < 5; ++i) {
        UIImage *image = [UIImage imageNamed:images[i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:NSSelectorFromString(selectors[i]) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [items addObject:barButton];
        
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    }
    
    [self setItems:items];
}

- (void)setIsStarred:(BOOL)isStarred {
    UIBarButtonItem *starBarButton = self.items[4];
    UIButton *starButton = (UIButton *)starBarButton.customView;
    
    if (isStarred) {
        [starButton setImage:[UIImage imageNamed:@"toolbar-starred"] forState:UIControlStateNormal];
    } else {
        [starButton setImage:[UIImage imageNamed:@"toolbar-star"] forState:UIControlStateNormal];
    }
    
    _isStarred = isStarred;
}


- (void)switchMode:(id)sender
{
    if (_switchMode) {_switchMode();}
}

- (void)showComments:(id)sender
{
    if (_showComments) {_showComments();}
}

- (void)toggleStar:(id)sender
{
    if (_toggleStar) {_toggleStar();}
}

- (void)share:(id)sender
{
    if (_share) {_share();}
}

- (void)report:(id)sender
{
    if (_report) {_report();}
}


- (void)addBorder
{
    UIView *upperBorder = [UIView new];
    upperBorder.backgroundColor = [UIColor lightGrayColor];
    upperBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:upperBorder];
    
    UIView *bottomBorder = [UIView new];
    bottomBorder.backgroundColor = [UIColor lightGrayColor];
    bottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomBorder];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(upperBorder, bottomBorder);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[upperBorder]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upperBorder(0.5)]->=0-[bottomBorder(0.5)]|"
                                                                 options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                 metrics:nil views:views]];
}



@end
