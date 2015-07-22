//
//  TweetDetailsWithBottomBarViewController.m
//  OSChina
//
//  Created by sky on 15/7/9.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TweetDetailsWithBottomBarViewController.h"
#import "TweetDetailsViewController.h"
#import "CommentsViewController.h"
#import "UserDetailsViewController.h"
#import "ImageViewController.h"
#import "OSCTweet.h"
#import "OSCComment.h"
#import "TweetDetailsCell.h"
#import "Config.h"
#import "Utils.h"
#import <objc/runtime.h>

@interface TweetDetailsWithBottomBarViewController ()

@property (nonatomic, strong) TweetDetailsViewController *tweetDetailsVC;
@property (nonatomic, assign) int64_t tweetID;
@property (nonatomic, assign) BOOL isReply;

@end

@implementation TweetDetailsWithBottomBarViewController

- (instancetype)initWithTweetID:(int64_t)tweetID {
    self = [super initWithModeSwitchButton:NO];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _tweetID = tweetID;
        
        _tweetDetailsVC = [[TweetDetailsViewController alloc] initWithTweetID:tweetID];
        [self addChildViewController:_tweetDetailsVC];
    
        [self setUpBlock];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setLayout {
    [self.view addSubview:_tweetDetailsVC.view];
    
    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{@"tableView": _tweetDetailsVC.view, @"bottomBar": self.editingBar};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView][bottomBar]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    
}

- (void)setUpBlock {
    __weak typeof (self)weakSelf = self;
    _tweetDetailsVC.didCommentSelected = ^(OSCComment *comment) {
        NSString *authorString = [NSString stringWithFormat:@"@%@",comment.author];
        if ([weakSelf.editingBar.editView.text rangeOfString:authorString].location == NSNotFound) {
            NSString *stringToInsert = [NSString stringWithFormat:@"@%@ ", comment.author];
            [weakSelf.editingBar.editView replaceRange:weakSelf.editingBar.editView.selectedTextRange withText:stringToInsert];
            [weakSelf.editingBar.editView becomeFirstResponder];
        }
    };

    _tweetDetailsVC.didScroll = ^ {
        [weakSelf.editingBar.editView resignFirstResponder];
        [weakSelf hideEmojiPageView];
    };
}


- (void)sendContent {
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"评论发送中";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_COMMENT_PUB]
       parameters:@{
                    @"catalog": @(3),
                    @"id": @(_tweetID),
                    @"uid": @([Config getOwnID]),
                    @"content": [Utils convertRichTextToRawText:self.editingBar.editView],
                    @"isPostToMyZone": @(0)
                    }
          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
              ONOXMLElement *result = [responseDocument.rootElement firstChildWithTag:@"result"];
              int errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] intValue];
              NSString *errorMessage = [[result firstChildWithTag:@"errorMessage"] stringValue];
              
              hub.mode = MBProgressHUDModeCustomView;
              
              if (errorCode == 1) {
                  self.editingBar.editView.text = @"";
                  [self updateInputBarHeight];
                  
                  hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                  hub.labelText = @"评论发表成功";
                  
                  [_tweetDetailsVC.tableView setContentOffset:CGPointZero animated:NO];
                  [_tweetDetailsVC refresh];
              } else {
                  hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                  hub.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
              }
              
              [hub hide:YES afterDelay:1];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              hub.mode = MBProgressHUDModeCustomView;
              hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
              hub.labelText = @"网络异常，动弹发送失败";
              
              [hub hide:YES afterDelay:1];
          }];

}

@end
