//
//  ShakingViewController.m
//  OSChina
//
//  Created by sky on 15/7/10.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "ShakingViewController.h"
#import "RandomMessageCell.h"

@interface ShakingViewController ()

@property (nonatomic, strong) UIView *layer;
@property (nonatomic, strong) RandomMessageCell *cell;

@end

@implementation ShakingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"摇一摇";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setLayout {
    _layer = [UIView new];
    _layer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_layer];
    
    UIImageView *imageUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_up"]];
    imageUp.contentMode = UIViewContentModeScaleAspectFill;
    [_layer addSubview:imageUp];
    
    UIImageView *imageDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_down"]];
    imageDown.contentMode = UIViewContentModeScaleAspectFill;
    [_layer addSubview:imageDown];
    
#if 0
    _cell = [RandomMessageCell new];
    UITapGestureRecognizer *tapGestureRacognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell)];
    [_cell addGestureRecognizer:tapGestureRacognizer];
    [_cell setHidden:YES];
    [self.view addSubview:_cell];
#endif
    
    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    for (UIView *view in _layer.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_layer, imageUp, imageDown);
    
    // layer
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_layer(195)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|->=50-[_layer(168.75)]->=50-|"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_layer
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f constant:0.f]];
    
    
    // imageUp and imageDown
    
    [_layer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[imageUp(168.75)]|" options:0 metrics:nil views:views]];
    [_layer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=1-[imageUp(95.25)][imageDown(95.25)]|"
                                                                   options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                   metrics:nil views:views]];
    
    // projectCell
    
    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cell(>=60)]|" options:0 metrics:nil views:views]];
    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_cell]|" options:0 metrics:nil views:views]];
}

- (void)tapCell
{
    
}

@end
