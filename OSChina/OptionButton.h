//
//  OptionButton.h
//  OSChina
//
//  Created by sky on 15/7/8.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionButton : UIView

@property (nonatomic, strong) UIButton *button;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andColor:(UIColor *)color;

@end
