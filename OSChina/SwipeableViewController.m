//
//  SwipeableViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "SwipeableViewController.h"
#import "HorizonalTableViewController.h"
#import "Utils.h"
#import "OSCAPI.h"
#import "TweetsViewController.h"

@interface SwipeableViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HorizonalTableViewController *viewPager;
@property (nonatomic, strong) TitleBarView *titleBar;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *controllers;

@end

@implementation SwipeableViewController

- (instancetype)initWithTitles:(NSArray *)titles andControllers:(NSArray *)controllers {
    self = [super init];
    if (self) {
        self.titles = titles;
        
        NSString *tmpVersionType = [UIDevice currentDevice].systemVersion;
        NSArray *tmpArr = [tmpVersionType componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
        int y = 0;
        if ([[tmpArr objectAtIndex:0] isEqualToString:@"7"]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            y = 64;
        }
        
        CGFloat titleBarHeight = 43;
        self.titleBar = [[TitleBarView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, titleBarHeight) andTitles:titles];
        self.titleBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.titleBar];
        
        self.viewPager = [[HorizonalTableViewController alloc] initWithViewControllers:controllers];
        self.viewPager.view.frame = CGRectMake(0, titleBarHeight + y, self.view.frame.size.width, self.view.frame.size.height - titleBarHeight - y);
        
        [self addChildViewController:self.viewPager];
        [self.view addSubview:self.viewPager.view];
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeColor];
    
    self.titles = @[@"最新动弹",@"热门动弹",@"我的动弹"];
    
    NSArray *controllers = @[[[TweetsViewController alloc] init],
                             [[TweetsViewController alloc] init],
                             [[TweetsViewController alloc] init]];
    
    CGFloat titleBarHeight = 43;
    self.titleBar = [[TitleBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleBarHeight) andTitles:self.titles];
    self.titleBar.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.titleBar];
    
    self.viewPager = [[HorizonalTableViewController alloc] initWithViewControllers:controllers];
    self.viewPager.view.frame = CGRectMake(0, titleBarHeight, self.view.frame.size.width, self.view.frame.size.height - titleBarHeight);
    
    [self addChildViewController:self.viewPager];
    [self.view addSubview:self.viewPager.view];
    
    // 滑动view时切换对应的 titleview
    __weak TitleBarView *weakTitleBar = self.titleBar;
    self.viewPager.focusViewIndexChanged = ^(NSUInteger index) {
        [weakTitleBar focusTitleAtIndex:index];
    };
    self.viewPager.scrollView = ^(CGFloat offsetRatio) {
        
    };
    
    //点击titleView上的button时 切换对应的view
    __weak HorizonalTableViewController *weakViewPager = self.viewPager;
    self.titleBar.titleButtonClicked = ^(NSUInteger index) {
        [weakViewPager scrollToViewAtIndex:index];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
