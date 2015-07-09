//
//  SwipeableViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "SwipeableViewController.h"
#import "Utils.h"


@interface SwipeableViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation SwipeableViewController

- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers {
    self = [super init];
    if (self) {
        if (title) {
            self.title = title;
        }
        
        CGFloat titleBarHeight = 43;
        self.titleBar = [[TitleBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleBarHeight) andTitles:subTitles];
        self.titleBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.titleBar];
        
        self.viewPager = [[HorizonalTableViewController alloc] initWithViewControllers:controllers];
        self.viewPager.view.frame = CGRectMake(0, titleBarHeight, self.view.frame.size.width, self.view.frame.size.height - titleBarHeight);
        [self addChildViewController:self.viewPager];
        [self.view addSubview:self.viewPager.view];
        
        // 滑动view时切换对应的 titleview
        __weak TitleBarView *weakTitleBar = self.titleBar;
        __weak HorizonalTableViewController *weakViewPager = self.viewPager;
        
        
        self.viewPager.changeIndex = ^(NSUInteger index) {
#if 1
            weakTitleBar.currentIndex = index;
            for (UIButton *button in weakTitleBar.titleButtons) {
                if (button.tag != index) {
                    [button setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
                } else {
                    [button setTitleColor:[UIColor colorWithHex:0x008000] forState:UIControlStateNormal];
                }
            }
#else
            UIButton *titleFrom = weakTitleBar.titleButtons[weakTitleBar.currentIndex];
            [titleFrom setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
            
            weakTitleBar.currentIndex = index;
            UIButton *titleTo = weakTitleBar.titleButtons[weakTitleBar.currentIndex];
            [titleTo setTitleColor:[UIColor colorWithHex:0x008000] forState:UIControlStateNormal];
#endif
            [weakViewPager scrollToViewAtIndex:index];
        };
        
        self.viewPager.scrollView = ^(CGFloat offsetRatio, NSUInteger index) {
            UIButton *titleFrom = weakTitleBar.titleButtons[weakTitleBar.currentIndex];

            [titleFrom setTitleColor:[UIColor colorWithRed:0.5*(1-offsetRatio) green:0.5 blue:0.5*(1-offsetRatio) alpha:1.0]
                            forState:UIControlStateNormal];
            
            UIButton *titleTo = weakTitleBar.titleButtons[index];
            
            [titleTo setTitleColor:[UIColor colorWithRed:0.5*offsetRatio green:0.5*(1-offsetRatio) blue:0*offsetRatio alpha:1.0]
                          forState:UIControlStateNormal];
        };
        
        //点击titleView上的button时 切换对应的view
        self.titleBar.titleButtonClicked = ^(NSUInteger index) {
            [weakViewPager scrollToViewAtIndex:index];
        };
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor themeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
