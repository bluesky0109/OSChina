//
//  DiscoverTableVC.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "DiscoverTableVC.h"
#import "EventsViewController.h"
#import "PersonSearchViewController.h"
#import "ScanViewController.h"
#import "ShakingViewController.h"
#import "SearchViewController.h"
#import "ActivitiesViewController.h"
#import "Config.h"
#import "UIColor+Util.h"

@interface DiscoverTableVC ()

@end

@implementation DiscoverTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.bounces = NO;
    
    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"好友圈";
            break;
        case 1:
            cell.textLabel.text = @[@"找人", @"活动"][indexPath.row];
            break;
        case 2:
            cell.textLabel.text = @[@"扫一扫", @"摇一摇"][indexPath.row];
            break;
        default:
            
            break;
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:[EventsViewController new] animated:YES];
            break;
            
        case 1: {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[PersonSearchViewController new] animated:YES];
            } else if (indexPath.row == 1) {
                SwipableViewController *activitySVC = [[SwipableViewController alloc] initWithTitle:@"活动" andSubTitles:@[@"近期活动", @"我的活动"] andControllers:@[[[ActivitiesViewController alloc] initWithUID:0], [[ActivitiesViewController alloc] initWithUID:[Config getOwnID]]]];
                activitySVC.hidesBottomBarWhenPushed = YES;
               [self.navigationController pushViewController:activitySVC animated:YES];
            }
            
            break;
        }
        
        case 2: {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[ScanViewController new] animated:YES];
            } else if (indexPath.row == 1) {
                [self.navigationController pushViewController:[ShakingViewController new] animated:YES];
            }
            
            break;
        }
        default:
            break;
    }
}


@end
