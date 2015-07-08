//
//  EmojiPageVC.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "EmojiPageVC.h"
#import "EmojiPanelVC.h"

@interface EmojiPageVC ()<UIPageViewControllerDataSource>

@end

@implementation EmojiPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    EmojiPanelVC *emojiPanelVC = [[EmojiPanelVC alloc] initWithPageIndex:0];
    if (emojiPanelVC != nil) {
        self.dataSource = self;
        [self setViewControllers:@[emojiPanelVC]
                       direction:UIPageViewControllerNavigationDirectionReverse
                        animated:NO
                      completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(EmojiPanelVC *)vc
{
    int index = vc.pageIndex;
    
    if (index == 0) {
        return nil;
    }
    return [[EmojiPanelVC alloc] initWithPageIndex:index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(EmojiPanelVC *)vc
{
    int index = vc.pageIndex;
    
    if (index == 5) {
        return nil;
    }
    return [[EmojiPanelVC alloc] initWithPageIndex:index+1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 6;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}




@end
