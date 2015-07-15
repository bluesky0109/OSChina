//
//  SideMenuViewController.m
//  OSChina
//
//  Created by sky on 15/7/12.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SwipableViewController.h"
#import "PostsViewController.h"
#import "BlogsViewController.h"
#import "SoftwareCatalogVC.h"
#import "SoftwareListVC.h"
#import "MyInfoViewController.h"
#import "SettingsPage.h"
#import "Utils.h"
#import "Config.h"

#import <RESideMenu.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor themeColor];
    
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu-QA", @"sidemenu-software", @"sidemenu-blog", @"", @"sidemenu-logout"][indexPath.row]];
    cell.textLabel.text = @[@"技术问答", @"开源软件", @"博客区", @"设置", @"注销"][indexPath.row];
    
    return cell;
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithHex:0x15A230];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"开源中国";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithHex:0xEEEEEE];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:titleLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel);
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-10-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[titleLabel]" options:0 metrics:nil views:views]];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:@"技术问答" andSubTitles:@[@"提问", @"分享", @"综合", @"职业", @"站务"] andControllers:@[[[PostsViewController alloc] initWithPostsType:PostsTypeQA],[[PostsViewController alloc] initWithPostsType:PostsTypeShare],[[PostsViewController alloc] initWithPostsType:PostsTypeSynthesis],[[PostsViewController alloc] initWithPostsType:PostsTypeCaree],[[PostsViewController alloc] initWithPostsType:PostsTypeSiteManager]]];
            
            [self setMenuContentViewController:newsSVC];
            
            break;
        }
            
        case 1: {
            
            SwipableViewController *softwareSVC = [[SwipableViewController alloc] initWithTitle:@"开源软件" andSubTitles:@[@"分类", @"推荐", @"最新", @"热门",@"国产"] andControllers:@[[[SoftwareCatalogVC alloc] initWithTag:0],[[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeRecommended],[[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeNewest],[[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeHottest],[[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeCN]]];
            
            [self setMenuContentViewController:softwareSVC];
            
            break;
        }
            
    
        case 2: {
            
            SwipableViewController *blogsSVC = [[SwipableViewController alloc] initWithTitle:@"博客区" andSubTitles:@[@"最新博客", @"推荐阅读"] andControllers:@[[[BlogsViewController alloc] initWithBlogsType:BlogsTypeLatest],[[BlogsViewController alloc] initWithBlogsType:BlogsTypeRecommended]]];
            
            [self setMenuContentViewController:blogsSVC];
            
            break;
        }
            
            
        case 3: {
            SettingsPage *settingPage = [SettingsPage new];
            [self setMenuContentViewController:settingPage];
            break;
        }
            
                    
        default:
            break;
    }
}

- (void)setMenuContentViewController:(UIViewController *)viewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToHomePage)];
    
    _reservedViewController = self.sideMenuViewController.contentViewController;
    [self.sideMenuViewController setContentViewController:navigationController];
    [self.sideMenuViewController hideMenuViewController];
}


- (void)backToHomePage
{
    [self.sideMenuViewController setContentViewController:_reservedViewController animated:NO];
    [self.sideMenuViewController hideMenuViewController];
}



@end
