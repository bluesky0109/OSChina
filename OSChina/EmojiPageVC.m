//
//  EmojiPageVC.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "EmojiPageVC.h"
#import "EmojiCollectionVC.h"

@interface EmojiPageVC ()<UIPageViewControllerDataSource>

@end

@implementation EmojiPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EmojiCollectionVC *emojiCollectionVC = [[EmojiCollectionVC alloc] initWithPageIndex:0];
    if (emojiCollectionVC != nil) {
        self.dataSource = self;
        
        [self setViewControllers:@[emojiCollectionVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(EmojiCollectionVC *)vc
{
    NSUInteger index = vc.pageIndex;
    
    if (index == 0) {
        return nil;
    }
    return [[EmojiCollectionVC alloc] initWithPageIndex:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(EmojiCollectionVC *)vc
{
    NSUInteger index = vc.pageIndex;
    
    if (index == 2) {
        return nil;
    }
    return [[EmojiCollectionVC alloc] initWithPageIndex:0];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}




@end
