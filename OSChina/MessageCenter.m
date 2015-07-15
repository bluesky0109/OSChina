//
//  MessageCenter.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "MessageCenter.h"
#import "OSCObjsViewController.h"
#import "EventsViewController.h"
#import "FriendsViewController.h"
#import "MessagesViewController.h"
#import "Config.h"
#import "UIButton+Badge.h"

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>

@interface MessageCenter ()

@property (nonatomic, strong) NSArray *noticesCount;

@end

@implementation MessageCenter

- (instancetype)initWithNoticeCounts:(NSArray *)noticeCounts
{
    
    self = [super initWithTitle:@"消息中心" andSubTitles:@[@"我",@"评论",@"留言",@"粉丝"] andControllers:@[[[EventsViewController alloc] initWithCatalog:2],[[EventsViewController alloc] initWithCatalog:3],[MessagesViewController new],[[FriendsViewController alloc] initWithUserID:[Config getOwnID] andFriendsRelation:0]]];
    
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        [self dealWithNotices:noticeCounts autoScroll:YES];
        
        [self.viewPager.controllers enumerateObjectsUsingBlock:^(OSCObjsViewController *vc, NSUInteger idx, BOOL *stop) {
            vc.didRefreshSucceed = ^ {
                UIButton *titleButton = weakSelf.titleBar.titleButtons[idx];
                if ([titleButton.badgeValue isEqualToString:@"0"]) {
                    return ;
                }
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];

                [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_NOTICE_CLEAR]
                   parameters:@{@"uid":@([Config getOwnID]),
                                @"type":@[@(1), @(3), @(2), @(4)][idx]}
                      success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
                          ONOXMLElement *result = [responseDocument.rootElement firstChildWithTag:@"result"];
                          int errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] intValue];
                          
                          if (errorCode == 1) {
                              UIButton *button = weakSelf.titleBar.titleButtons[idx];
                              button.badge.hidden = YES;
                          }
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                  }];
            };
        }];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeUpdateHandler:) name:OSCAPI_USER_NOTICE object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 处理消息通知

#pragma mark - 处理badge
- (void)setBadgeValue:(NSString *)badgeValue forButton:(UIButton *)button {
    if ([badgeValue isEqualToString:@"0"]) {
        button.badge.hidden = YES;
        return;
    }
    
    CGSize size = [button.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    button.badgeValue = badgeValue;
    button.badgeOriginX = (button.frame.size.width + size.width) / 2;
    button.badgeOriginY = (button.frame.size.height - button.badge.frame.size.height) / 2;
    button.badgeBGColor = [UIColor redColor];
    button.badgeTextColor = [UIColor whiteColor];
}

#pragma mark - 处理提示
- (void)dealWithNotices:(NSArray *)noticeCounts autoScroll:(BOOL)needAutoScroll{
    __block BOOL scrolled = NO;
    __block int sumOfCount = 0;
    
    [self.titleBar.titleButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [self setBadgeValue:[noticeCounts[idx] stringValue] forButton:button];
        sumOfCount += [noticeCounts[idx] intValue];
        
        if (needAutoScroll && [noticeCounts[idx] intValue] && !scrolled) {
            [self scrollToViewAtIndex:idx];
            scrolled = YES;
        }
    }];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:sumOfCount];
}

#pragma mark - 处理系统通知 （定时请求的）
- (void)noticeUpdateHandler:(NSNotification *)notification {
    NSArray *noticeCounts = [notification object];
    
    [self dealWithNotices:noticeCounts autoScroll:NO];
}

@end
