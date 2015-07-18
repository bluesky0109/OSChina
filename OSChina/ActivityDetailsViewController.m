//
//  ActivityDetailsViewController.m
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "ActivitySignUpViewController.h"
#import "PresentMembersViewController.h"
#import "ActivityDetailsWithBarViewController.h"
#import "OSCActivity.h"
#import "ActivityBasicInfoCell.h"
#import "ActivityDetailsCell.h"
#import "OSCAPI.h"
#import "OSCPostDetails.h"
#import "Utils.h"
#import "UIBarButtonItem+Badge.h"

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>


@interface ActivityDetailsViewController ()<UIWebViewDelegate>
{
    OSCPostDetails *postDetails;
}

@property (nonatomic, readonly, strong) OSCActivity *activity;

@property (nonatomic, copy  ) NSString *HTML;
@property (nonatomic, assign) BOOL     isLoadingFinished;
@property (nonatomic, assign) CGFloat  webViewHeight;

@end

@implementation ActivityDetailsViewController

- (instancetype)initWithActivity:(OSCActivity *)activity {
    self = [super init];
    if (self) {
        _activity = activity;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    self.view.backgroundColor = [UIColor themeColor];
    
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@?id=%lld", OSCAPI_PREFIX, OSCAPI_POST_DETAIL, _activity.activityID]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
             ONOXMLElement *postXML = [responseObject.rootElement firstChildWithTag:@"post"];
             postDetails = [[OSCPostDetails alloc] initWithXML:postXML];
             _HTML = [postDetails.body copy];
             
             UIBarButtonItem *commentsCountButton = _bottomBarVC.operationBar.items[4];
             commentsCountButton.shouldHideBadgeAtZero = YES;
             commentsCountButton.badgeValue = [NSString stringWithFormat:@"%i", postDetails.answerCount];
             commentsCountButton.badgePadding = 1;
             commentsCountButton.badgeBGColor = [UIColor colorWithHex:0x24a83d];
             
             [self.tableView reloadData];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"wrong");
         }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            ActivityBasicInfoCell *cell = [ActivityBasicInfoCell new];
            cell.titleLabel.text = _activity.title;
            cell.timeLabel.text = [NSString stringWithFormat:@"开始：%@\n结束：%@", _activity.startTime, _activity.endTime];
            cell.locationLabel.text = [NSString stringWithFormat:@"地点：%@ %@", _activity.city, _activity.location];
            
            
            if (postDetails.applyStatus == 0) {
                [cell.applicationButton setTitle:@"审核中" forState:UIControlStateNormal];
            } else if (postDetails.applyStatus == 1) {
                [cell.applicationButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.applicationButton setTitle:@"你的报名已确认，现场可以扫描二维码签到！" forState:UIControlStateNormal];
                cell.applicationButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.applicationButton setBackgroundColor:[UIColor clearColor]];
            } else {
                
                if (postDetails.applyStatus == 2) {
                    [cell.applicationButton setTitle:@"出席人员" forState:UIControlStateNormal];
                }
                
                if (postDetails.category == 4) {
                    [cell.applicationButton setTitle:@"报名链接" forState:UIControlStateNormal];
                }

                 [cell.applicationButton addTarget:self action:@selector(enrollActivity) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            return cell;
        }
          
        case 1: {
            UITableViewCell *cell = [UITableViewCell new];
            cell.textLabel.text = @"活动详情";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.backgroundColor = [UIColor themeColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        case 2: {
            ActivityDetailsCell *cell = [ActivityDetailsCell new];
            cell.webView.delegate = self;
            [cell.webView loadHTMLString:_HTML baseURL:nil];
            
            return cell;
        }
            
        default:
            return nil;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            UILabel *label = [UILabel new];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            CGFloat width = tableView.frame.size.width - 16;
            
            label.font = [UIFont boldSystemFontOfSize:16];
            label.text = _activity.title;
            CGFloat height = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
            
            label.font = [UIFont systemFontOfSize:13];
            label.text = [NSString stringWithFormat:@"开始：%@\n结束：%@", _activity.startTime, _activity.endTime];
            height += [label sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
            
            label.text = _activity.location;
            height += [label sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
            
            return height + 95;
        }
        case 1:
            return 35;
        case 2:
            return _webViewHeight + 30;
        default:
            return 0;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_isLoadingFinished) {
        webView.hidden = NO;
        return;
    }
    
    _webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    //设置为已经加载完成
    _isLoadingFinished = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [Utils analysis:[request.URL absoluteString] andNavController:self.navigationController];
    return [request.URL.absoluteString isEqualToString:@"about:blank"];

}

// postDetails.status, postDetails.applyStatus
#pragma mark - 报名
- (void)enrollActivity
{
    if (postDetails.category == 4) {
        [[UIApplication sharedApplication] openURL:postDetails.signUpUrl];
    } else {
        if (postDetails.applyStatus == 2) {

            PresentMembersViewController *presentMembersViewController = [[PresentMembersViewController alloc] initWithEventID:postDetails.postID];
            [_bottomBarVC.navigationController pushViewController:presentMembersViewController animated:YES];
        } else {
        
            ActivitySignUpViewController *signUpVC = [ActivitySignUpViewController new];
            signUpVC.eventId = postDetails.postID;
            [_bottomBarVC.navigationController pushViewController:signUpVC animated:YES];
        }
    }
}

@end
