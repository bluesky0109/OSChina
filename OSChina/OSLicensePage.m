//
//  OSLicensePage.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSLicensePage.h"

@interface OSLicensePage ()

@end

@implementation OSLicensePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开源组件";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    webView.scrollView.bounces = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"OSLicense" ofType:@"html"] isDirectory:NO]]];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
