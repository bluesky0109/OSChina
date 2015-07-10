//
//  ShakingViewController.m
//  OSChina
//
//  Created by sky on 15/7/10.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "ShakingViewController.h"

@interface ShakingViewController ()

@property (nonatomic, strong) UIView *layer;

@end

@implementation ShakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"摇一摇";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setLayout {
    _layer = [UIView new];
    _layer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_layer];
    
    UIImageView *imageUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_logo_up"]];
    imageUp.contentMode = UIViewContentModeScaleAspectFill;
    [_layer addSubview:imageUp];
    
    UIImageView *imageDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_logo_down"]];
    imageDown.contentMode = UIViewContentModeScaleAspectFill;
    [_layer addSubview:imageDown];
    
    
    
    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
}

@end
