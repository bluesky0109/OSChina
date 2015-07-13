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
        
        CGFloat titleBarHeight = 38;
        self.titleBar = [[TitleBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleBarHeight) andTitles:subTitles];
        self.titleBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.titleBar];
        
        self.viewPager = [[HorizonalTableViewController alloc] initWithViewControllers:controllers];
        self.viewPager.view.frame = CGRectMake(0, titleBarHeight, self.view.frame.size.width, self.view.frame.size.height - titleBarHeight);
        [self addChildViewController:self.viewPager];
        [self.view addSubview:self.viewPager.view];
        
        // 滑动view时切换对应的 titleview
        __block TitleBarView *weakTitleBar = self.titleBar;
        __block HorizonalTableViewController *weakViewPager = self.viewPager;
        
        
        self.viewPager.changeIndex = ^(NSUInteger index) {
            weakTitleBar.currentIndex = index;
            for (UIButton *button in weakTitleBar.titleButtons) {
                if (button.tag != index) {
                    [button setTitleColor:[UIColor colorWithHex:0x909090] forState:UIControlStateNormal];
                    button.transform = CGAffineTransformIdentity;
                } else {
                    [button setTitleColor:[UIColor colorWithHex:0x009000] forState:UIControlStateNormal];
                    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }
            }

            [weakViewPager scrollToViewAtIndex:index];
        };
        
        self.viewPager.scrollView = ^(CGFloat offsetRatio, NSUInteger index) {
            if (index > weakTitleBar.currentIndex) {
                offsetRatio = 1- offsetRatio;
            }
            
            UIButton *titleFrom = weakTitleBar.titleButtons[weakTitleBar.currentIndex];
            UIButton *titleTo = weakTitleBar.titleButtons[index];
            
            CGFloat colorValue = (CGFloat)0x90 / 0xFF;
            
            [UIView transitionWithView:titleFrom duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [titleFrom setTitleColor:[UIColor colorWithRed:colorValue*(1-offsetRatio) green:colorValue blue:colorValue*(1-offsetRatio) alpha:1.0] forState:UIControlStateNormal];
                titleTo.transform = CGAffineTransformMakeScale(1 + 0.2 * offsetRatio, 1 + 0.2 * offsetRatio);
            } completion:nil];
            
            [UIView transitionWithView:titleTo duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [titleTo setTitleColor:[UIColor colorWithRed:colorValue*offsetRatio green:colorValue blue:colorValue*offsetRatio alpha:1.0] forState:UIControlStateNormal];
                titleTo.transform = CGAffineTransformMakeScale(1 + 0.2 * (1-offsetRatio), 1 + 0.2 * (1-offsetRatio));
            } completion:nil];
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
