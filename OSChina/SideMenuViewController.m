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
#import "LoginViewController.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"userRefresh" object:nil];
    
    self.tableView.bounces = NO;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"menu-background(%dx%d)", (int)screenSize.width, (int)screenSize.height]];
    NSLog(@"%@", [NSString stringWithFormat:@"menu-background(%dx%d)", (int)screenSize.width, (int)screenSize.height]);
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
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
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithHex:0x696969];
    cell.textLabel.font = [UIFont systemFontOfSize:21];
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu-QA", @"sidemenu-software", @"sidemenu-blog", @"sidemenu-settings"][indexPath.row]];
    cell.textLabel.text = @[@"技术问答", @"开源软件", @"博客区", @"设置", @"注销"][indexPath.row];
    
    return cell;
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *userInformation = [Config getUsersInformation];
    UIImage *portrait = [Config getPortrait];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    

    UIImageView *portraitView = [UIImageView new];
    portraitView.contentMode = UIViewContentModeScaleAspectFit;
    [portraitView setCornerRadius:30];
    portraitView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:portraitView];
    
    if (portrait == nil) {
        portraitView.image = [UIImage imageNamed:@"default-portrait"];
    } else {
        portraitView.image = portrait;
    }

    UILabel *nameLabel = [UILabel new];
    nameLabel.text = userInformation.firstObject;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.textColor = [UIColor colorWithHex:0x696969];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];

    NSDictionary *views = NSDictionaryOfVariableBindings(portraitView, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[portraitView(60)]-10-[nameLabel]-25-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[portraitView(60)]" options:0 metrics:metrics views:views]];

    portraitView.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    [portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:@"技术问答" andSubTitles:@[@"提问", @"分享", @"综合", @"职业", @"站务"] andControllers:@[[[PostsViewController alloc] initWithPostsType:PostsTypeQA],[[PostsViewController alloc] initWithPostsType:PostsTypeShare],[[PostsViewController alloc] initWithPostsType:PostsTypeSynthesis],[[PostsViewController alloc] initWithPostsType:PostsTypeCaree],[[PostsViewController alloc] initWithPostsType:PostsTypeSiteManager]]];
            
            [self setContentViewController:newsSVC];
            
            break;
        }
            
        case 1: {
            
            SwipableViewController *softwareSVC = [[SwipableViewController alloc] initWithTitle:@"开源软件" andSubTitles:@[@"分类", @"推荐", @"最新", @"热门",@"国产"] andControllers:@[[[SoftwareCatalogVC alloc] initWithTag:0],[[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeRecommended],[[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeNewest],[[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeHottest],[[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeCN]]];
            
            [self setContentViewController:softwareSVC];
            
            break;
        }
            
    
        case 2: {
            
            SwipableViewController *blogsSVC = [[SwipableViewController alloc] initWithTitle:@"博客区" andSubTitles:@[@"最新博客", @"推荐阅读"] andControllers:@[[[BlogsViewController alloc] initWithBlogsType:BlogsTypeLatest],[[BlogsViewController alloc] initWithBlogsType:BlogsTypeRecommended]]];
            
            [self setContentViewController:blogsSVC];
            
            break;
        }
            
            
        case 3: {
            SettingsPage *settingPage = [SettingsPage new];
            [self setContentViewController:settingPage];
            break;
        }
            
        
        default:
            break;
    }
}

- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    
    [nav pushViewController:viewController animated:NO];
    [self.sideMenuViewController hideMenuViewController];
}


#pragma mark - 点击头像

- (void)pushLoginPage
{
    if ([Config getOwnID] == 0) {
        [self setContentViewController:[LoginViewController new]];
    } else {
        return;
    }
}

- (void)reload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
@end
