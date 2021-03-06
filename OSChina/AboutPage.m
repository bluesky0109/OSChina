//
//  AboutPage.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "AboutPage.h"
#import "OSLicensePage.h"
#import "Utils.h"

@interface AboutPage ()

@end

@implementation AboutPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = [UIColor themeColor];
    
    UIImageView *logo = [UIImageView new];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logo];
    
    UILabel *declarationLabel = [UILabel new];
    declarationLabel.numberOfLines = 0;
    declarationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    declarationLabel.textAlignment = NSTextAlignmentCenter;
    declarationLabel.textColor = [UIColor lightGrayColor];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    declarationLabel.text = [NSString stringWithFormat:@"%@\n©2008-2015 oschina.net.\nAll rights reserved.", version];
    [self.view addSubview:declarationLabel];
    
    UILabel *OSLicenseLabel = [UILabel new];
    OSLicenseLabel.textColor = [UIColor colorWithHex:0x4169E1];
    OSLicenseLabel.text = @"开源许可";
    OSLicenseLabel.userInteractionEnabled = YES;
    [OSLicenseLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickOSLicenseLabel)]];
    [self.view addSubview:OSLicenseLabel];
    
    for (UIView *view in self.view.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    NSDictionary *views = NSDictionaryOfVariableBindings(logo, declarationLabel);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:logo      attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:logo      attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:-90.f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logo(80)]-20-[declarationLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[logo(80)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[declarationLabel(200)]" options:0 metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:OSLicenseLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view      attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:OSLicenseLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view      attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-50.f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickOSLicenseLabel {
    [self.navigationController pushViewController:[OSLicensePage new] animated:YES];
}

@end
