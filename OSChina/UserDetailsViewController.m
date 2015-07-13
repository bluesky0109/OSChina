//
//  UserDetailsViewController.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "SwipeableViewController.h"
#import "FriendsViewController.h"
#import "BlogsViewController.h"
#import "OSCUser.h"
#import "OSCEvent.h"
#import "EventCell.h"
#import "UserHeaderCell.h"
#import "UserOperationCell.h"
#import "Utils.h"
#import "Config.h"

#import <Ono.h>

@interface UserDetailsViewController ()

@property (nonatomic, strong) OSCUser *user;

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *countLabel;
@property (nonatomic, strong) UIButton    *followButton;

@end

@implementation UserDetailsViewController

- (instancetype)initWithUserID:(int64_t)userID {
    self = [super initWithUserID:userID];
    
    if (!self) {return self;}
    self.hidesBottomBarWhenPushed = YES;
    
    __block UserDetailsViewController *weakSelf = self;
    self.parseExtraInfo = ^(ONOXMLDocument *XML) {
        ONOXMLElement *userXML = [XML.rootElement firstChildWithTag:@"user"];
        weakSelf.user = [[OSCUser alloc] initWithXML:userXML];
    };
    
    return self;
}

- (instancetype)initWithUserName:(NSString *)userName {
    self = [super initWithUserName:userName];
    self.hidesBottomBarWhenPushed = YES;
    if (!self) {
        return self;
    }
    
    __block UserDetailsViewController *weakSelf = self;
    self.parseExtraInfo = ^(ONOXMLDocument *XML) {
        ONOXMLElement *userXML = [XML.rootElement firstChildWithTag:@"user"];
        weakSelf.user = [[OSCUser alloc] initWithXML:userXML];
    };
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"用户中心";
    self.tableView.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0 ? 2 : self.objects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 158;
        } else {
            return 105;
        }

    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserHeaderCell *cell = [UserHeaderCell new];
            
            [cell setContentWithUser:_user];
            
            [cell.followsButton addTarget:self action:@selector(pushFriendsSVC) forControlEvents:UIControlEventTouchUpInside];
            [cell.fansButton addTarget:self action:@selector(pushFriendsSVC) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else {
            UserOperationCell *cell = [UserOperationCell new];
            if (_user) {
                cell.loginTimeLabel.text = [NSString stringWithFormat:@"上次登录：%@", [Utils intervalSinceNow:_user.latestOnlineTime]];
                [cell setFollowButtonByRelationship:_user.relationship];
            }
            return cell;
        }

    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}




- (void)setMiddleView:(UIView *)middleView
{
    void (^customizeButton)(UIButton *) = ^(UIButton *button) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        button.layer.borderWidth = 0.5;
        [button setTitleColor:[UIColor colorWithHex:0x494949] forState:UIControlStateNormal];
        [button setCornerRadius:5.0];
        button.translatesAutoresizingMaskIntoConstraints = NO;
    };
    
    _followButton = [UIButton new];
    customizeButton(_followButton);
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];         //需要修改
    [middleView addSubview:_followButton];
    
    UIButton *messageButton = [UIButton new];
    customizeButton(messageButton);
    [messageButton setTitle:@"留言" forState:UIControlStateNormal];
    [middleView addSubview:messageButton];
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_followButton, messageButton);
    
    [middleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_followButton(30)]->=10-|" options:0 metrics:nil views:viewsDict]];
    [middleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_followButton(100)]->=10-[messageButton(100)]-20-|"
                                                                       options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                       metrics:nil views:viewsDict]];
}




#pragma mark - Layout

- (void)pushFriendsSVC {
    SwipeableViewController *friendsSVC = [[SwipeableViewController alloc] initWithTitle:@"关注/粉丝"
                                                                            andSubTitles:@[@"关注", @"粉丝"]
                                                                          andControllers:@[
                                                                                           [[FriendsViewController alloc] initWithUserID:_user.userID andFriendsRelation:1],
                                                                                           [[FriendsViewController alloc] initWithUserID:_user.userID andFriendsRelation:0]
                                                                                           ]];
     friendsSVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:friendsSVC animated:YES];
}


@end
