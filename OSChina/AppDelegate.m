//
//  AppDelegate.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Util.h"
#import "SwipeableViewController.h"
#import "TweetsViewController.h"
#import "PostsViewController.h"
#import "NewsViewController.h"
#import "BlogsViewController.h"
#import "LoginViewController.h"
#import "DiscoverTableVC.h"
#import "SoftwareCatalogVC.h"
#import "SoftwareListVC.h"
#import "MyInfoViewController.h"
#import "Config.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
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
    
    SwipeableViewController *postsSVC = [[SwipeableViewController alloc] initWithTitle:@"讨论区"
                                                                          andSubTitles:@[@"问答", @"分享", @"综合", @"职业", @"站务"]
                                                                        andControllers:@[
                                                                                         [[PostsViewController alloc] initWithPostsType:PostsTypeQA],
                                                                                         [[PostsViewController alloc] initWithPostsType:PostsTypeShare],
                                                                                         [[PostsViewController alloc] initWithPostsType:PostsTypeSynthesis],
                                                                                         [[PostsViewController alloc] initWithPostsType:PostsTypeSiteManager],
                                                                                         [[PostsViewController alloc] initWithPostsType:PostsTypeCaree]
                                                                                         ]];

    
#if 0
    SwipeableViewController *softwareVC = [[SwipeableViewController alloc] initWithTitle:@"开源软件"
                                                                          andSubTitles:@[@"分类", @"推荐", @"最新", @"热门", @"国产"]
                                                                        andControllers:@[
                                                                                         [[SoftwareCatalogVC alloc] initWithTag:0],
                                                                                         [[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeRecommended],
                                                                                         [[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeNewest],
                                                                                         [[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeHottest],
                                                                                         [[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeCN]
                                                                                         ]];
#endif
    
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
    UINavigationController *postsNav = [[UINavigationController alloc] initWithRootViewController:postsSVC];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverVC];

//    UINavigationController *softwareNav = [[UINavigationController alloc] initWithRootViewController:softwareVC];
    
    
    self.tabBarController = [UITabBarController new];
    self.tabBarController.delegate = self;
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.viewControllers = @[newsNav,tweetsNav, discoverNav,meNav];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHex:0xE1E1E1]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x007F00]}  forState:UIControlStateSelected];
    
    NSArray *titles = @[@"资讯", @"动弹", @"发现", @"我"];
    for (NSUInteger i = 0, count = self.tabBarController.tabBar.items.count; i < count; i++) {
        [self.tabBarController.tabBar.items[i] setTitle:titles[i]];
    }
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0x008000]];
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];               //UIColorFromRGB(0xdadada)

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
