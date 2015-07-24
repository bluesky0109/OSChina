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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorColor = [UIColor colorWithHex:0xDDDDDD];
    
    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
            
        case 1: return 2;
            
        case 2: return 2;

        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = @"好友圈";
            cell.imageView.image = [UIImage imageNamed:@"discover-events"];
            break;
        }
            
        case 1: {
            cell.textLabel.text = @[@"找人", @"活动"][indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@[@"discover-search", @"discover-activities"][indexPath.row]];
            break;
        }
            
        case 2: {
            cell.textLabel.text = @[@"扫一扫", @"摇一摇"][indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@[@"discover-scan", @"discover-shake"][indexPath.row]];
            break;
        }
            
        default:
            
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            EventsViewController *eventsVC = [EventsViewController new];
            eventsVC.needCache = YES;
            
            [self.navigationController pushViewController:eventsVC animated:YES];
            break;

        }
    
        case 1: {
            if (indexPath.row == 0) {
                PersonSearchViewController *personSearchVC = [PersonSearchViewController new];
                personSearchVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:personSearchVC animated:YES];
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
