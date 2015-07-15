//
//  HorizonalTableViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "HorizonalTableViewController.h"
#import "Utils.h"

static NSString *kHorizonalCellID = @"HorizonalCell";


@interface HorizonalTableViewController ()


@end

@implementation HorizonalTableViewController

- (instancetype)initWithViewControllers:(NSArray *)controllers {
    self = [super init];
    if (self) {
        self.controllers = controllers;
        
        for (UIViewController *controller in controllers) {
            [self addChildViewController:controller];
        }
        
        self.tableView = [UITableView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollsToTop = NO;
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.pagingEnabled = YES;
        self.tableView.backgroundColor = [UIColor themeColor];
        self.tableView.bounces = NO;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHorizonalCellID];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.controllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHorizonalCellID forIndexPath:indexPath];
    
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.contentView.backgroundColor = [UIColor themeColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIViewController *controller = self.controllers[indexPath.row];
    controller.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:controller.view];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.width;
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollStop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollStop:NO];
}

#pragma mark -- private
- (void)scrollStop:(BOOL)didScrollStop {
    CGFloat horizontalOffset = self.tableView.contentOffset.y;
    CGFloat screenWidth = self.tableView.frame.size.width;
    CGFloat offsetRatio = (NSUInteger)horizontalOffset % (NSUInteger)screenWidth / screenWidth;
    NSUInteger focusIndex = (horizontalOffset + screenWidth / 2) / screenWidth;
    
    if (self.scrollView) {
        if (horizontalOffset != focusIndex * screenWidth) {
            NSUInteger animationIndex = horizontalOffset > focusIndex * screenWidth ? focusIndex + 1: focusIndex - 1;
            if (focusIndex > animationIndex) {
                offsetRatio = 1 - offsetRatio;
            }
            self.scrollView(offsetRatio,focusIndex,animationIndex);
        }
        
    }
    if (didScrollStop && self.changeIndex) {
        self.changeIndex(focusIndex);
    }
}

#pragma mark -- public
- (void)scrollToViewAtIndex:(NSUInteger)index {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

@end
