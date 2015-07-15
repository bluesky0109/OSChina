//
//  SettingsPage.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "SettingsPage.h"
#import "Utils.h"
#import "Config.h"
#import "MyInfoViewController.h"
#import "AboutPage.h"

#import <RESideMenu.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>

@interface SettingsPage ()

@end

@implementation SettingsPage

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if ([Config getOwnID] == 0) {
        return 2;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
            
        case 1:
            return 4;
            break;
        
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    NSArray *titles = @[
                        @[@"清理缓存", @"消息通知"],
                        @[@"意见反馈", @"给应用评分", @"关于", @"开源许可"],
                        @[@"注销登录"],
                        ];
    cell.textLabel.text = titles[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
        } else if (row == 1) {
            
        }
    } else if (section == 1) {
        if (row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/kai-yuan-zhong-guo/id524298520?mt=8"]];
        } else if (row == 2) {
            [self.navigationController pushViewController:[AboutPage new] animated:YES];
        }
    } else if (section == 2) {
#if 0
        [Config saveOwnID:0];
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
            [cookieStorage deleteCookie:cookie];
        }
        
        MBProgressHUD *HUD = [Utils createHUDInWindowOfView:self.view];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        HUD.labelText = @"注销成功";
        [HUD hide:YES afterDelay:0.5];
        
        UITabBarController *tabBarController = (UITabBarController *)self.sideMenuViewController.contentViewController;
        MyInfoViewController *myInfoVC = ((UINavigationController *)tabBarController.viewControllers[4]).viewControllers[0];
        [myInfoVC refreshView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
#endif
    }
    
}

@end
