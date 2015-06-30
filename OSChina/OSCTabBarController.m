//
//  OSCTabBarController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCTabBarController.h"
#import "ViewController.h"
#import "TweetsViewController.h"

@interface OSCTabBarController ()

@end

@implementation OSCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadViewControllers {
    
    ViewController *newsSVC = [[ViewController alloc] init];
    TweetsViewController *tweetsSVC = [[TweetsViewController alloc] init];
    ViewController *discoverVC = [[ViewController alloc] init];


    self.tabBar.translucent = NO;
    self.viewControllers = @[
                             newsSVC,tweetsSVC,discoverVC
                             ];
    
    
    NSArray *titles = @[@"资讯", @"动弹", @"最新动弹"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"tabbar-discover"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];

}


@end
