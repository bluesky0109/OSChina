//
//  MessageCenter.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "MessageCenter.h"
#import "Config.h"
#import "EventsViewController.h"
#import "FriendsViewController.h"
#import "MessagesViewController.h"

#import "UIButton+Badge.h"

@interface MessageCenter ()

@property (nonatomic, strong) NSArray *noticesCount;

@end

@implementation MessageCenter

- (instancetype)init//WithNoticeCounts:(NSArray *)noticeCounts
{
    
    self = [super initWithTitle:@"消息中心" andSubTitles:@[@"我",@"评论",@"留言",@"粉丝"] andControllers:@[[[EventsViewController alloc] initWithCatalog:2],[[EventsViewController alloc] initWithCatalog:3],[MessagesViewController new],[[FriendsViewController alloc] initWithUserID:[Config getOwnID] andFriendsRelation:0]]];
    
    if (self) {
        //_noticesCount = noticeCounts;
        
        [self.titleBar.titleButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            CGSize size = [button.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            button.badgeValue = @"1";
            button.badgeOriginX = (button.frame.size.width + size.width) / 2;
            button.badgeOriginY = (button.frame.size.height - size.height) / 2;
            button.badgeBGColor = [UIColor redColor];
            button.badgeTextColor = [UIColor whiteColor];
        }];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
