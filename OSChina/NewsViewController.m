//
//  NewsViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "OSCNews.h"
#import "NewsCell.h"
#import "Utils.h"
#import "OSCAPI.h"
#import "LastCell.h"

static NSString *kNewsCellID = @"NewsCell";


@interface NewsViewController ()

@property (nonatomic, strong) NSMutableArray *news;

@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) LastCell *lastCell;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.news = [NSMutableArray new];
    
    // tableView设置
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:kNewsCellID];
    self.tableView.backgroundColor = [UIColor themeColor];
    
    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
    
    //刷新
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    //用于计算高度
    self.lable = [UILabel new];
    
    self.lastCell = [[LastCell alloc] initCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.news.count > 0 || self.lastCell.status == LastCellStatusFinished) {
        return;
    }
    
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl.frame.size.height) animated:YES];
//    [self fetchNewsOnPage:0 refresh:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.lastCell.status == LastCellStatusNotVisible) {
        return self.news.count;
    }
    
    return self.news.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.news.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellID forIndexPath:indexPath];
        
        OSCNews *news = [self.news objectAtIndex:indexPath.row];
        
        
        
        return cell;
    } else {
        return self.lastCell;
    }
    
}



@end
