//
//  OSCTabBarController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCTabBarController.h"
#import "SwipeableViewController.h"
#import "TweetsViewController.h"
#import "PostsViewController.h"
#import "NewsViewController.h"
#import "BlogsViewController.h"
#import "LoginViewController.h"
#import "DiscoverTableVC.h"
#import "MyInfoViewController.h"
#import "TabBarCenterButton.h"
#import "Config.h"

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
    
    SwipeableViewController *newsSVC = [[SwipeableViewController alloc] initWithTitle:@"资讯"
                                                                         andSubTitles:@[@"最新资讯", @"本周热点", @"本月热点"]
                                                                       andControllers:@[
                                                                                        [[NewsViewController alloc] initWithNewsListType:NewsListTypeNews],
                                                                                        [[NewsViewController alloc] initWithNewsListType:NewsListTypeAllTypeWeekHottest],
                                                                                        [[NewsViewController alloc] initWithNewsListType:NewsListTypeAllTypeMonthHottest]
                                                                                        ]];

    SwipeableViewController *tweetsSVC = [[SwipeableViewController alloc] initWithTitle:@"动弹"
                                                                           andSubTitles:@[@"最新动弹", @"热门动弹", @"我的动弹"]
                                                                         andControllers:@[
                                                                                          [[TweetsViewController alloc] initWithTweetsType:TweetsTypeAllTweets],
                                                                                          [[TweetsViewController alloc] initWithTweetsType:TweetsTypeHotestTweets],
                                                                                          [[TweetsViewController alloc] initWithTweetsType:TweetsTypeOwnTweets]
                                                                                          ]];

    DiscoverTableVC *discoverVC = [DiscoverTableVC new];

    UINavigationController *meNav;
    if ([Config getOwnID] > 0) {
        MyInfoViewController *myInfoVC = [[MyInfoViewController alloc] initWithUserId:[Config getOwnID]];
        meNav = [[UINavigationController alloc] initWithRootViewController:myInfoVC];
    } else {
        LoginViewController *loginVC = [LoginViewController new];
        meNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }



    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:newsSVC];
    UINavigationController *tweetsNav = [[UINavigationController alloc] initWithRootViewController:tweetsSVC];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverVC];

    self.tabBar.translucent = NO;
    self.viewControllers = @[newsNav,tweetsNav,[UIViewController new], discoverNav,meNav];

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHex:0xE1E1E1]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x007F00]}  forState:UIControlStateSelected];
    
    NSArray *titles = @[@"资讯", @"动弹", @"", @"发现", @"我"];
    for (NSUInteger i = 0, count = self.tabBar.items.count; i < count; i++) {
        [self.tabBar.items[i] setTitle:titles[i]];
    }
    
    [self.tabBar.items[2] setEnabled:NO];
    
    
    TabBarCenterButton *centerButton = [[TabBarCenterButton alloc] initWithTabBar:self.tabBar];
}


@end
