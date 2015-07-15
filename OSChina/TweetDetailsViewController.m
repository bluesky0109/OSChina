//
//  TweetDetailsViewController.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UserDetailsViewController.h"
#import "ImageViewController.h"
#import "TweetDetailsCell.h"
#import "OSCTweet.h"
#import "TweetCell.h"
#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <MBProgressHUD.h>

@interface TweetDetailsViewController ()<UIWebViewDelegate>

@property (nonatomic, assign, readwrite) int64_t objectAuthorID;

@property (nonatomic, strong) OSCTweet *tweet;
@property (nonatomic, assign) int64_t  tweetID;

@property (nonatomic, assign) BOOL     isLoadingFinished;
@property (nonatomic, assign) CGFloat  webViewHeight;

@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation TweetDetailsViewController

- (instancetype)initWithTweetID:(int64_t)tweetID {
    self = [super initWithCommentType:CommentTypeTweet andObjectID:tweetID];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.tweetID = tweetID;

        __weak TweetDetailsViewController *weakSelf = self;
        self.otherSectionCell = ^(NSIndexPath *indexPath) {
      
            TweetDetailsCell *cell = [TweetDetailsCell new];
            
            if (weakSelf.tweet) {
                [cell.portrait loadPortrait:weakSelf.tweet.portraitURL];
                [cell.authorLabel setText:weakSelf.tweet.author];
                [cell.timeLabel setText:[Utils intervalSinceNow:weakSelf.tweet.pubDate]];
                [cell.appclientLabel setText:[Utils getAppclient:weakSelf.tweet.appclient]];
                cell.webView.delegate = weakSelf;
                [cell.webView loadHTMLString:weakSelf.tweet.body baseURL:nil];
            }
            
            return cell;
        };
        
        self.heightForOtherSectionCell = ^(NSIndexPath *indexPath) {
            
            return weakSelf.webViewHeight + 60;
        };

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _HUD = [Utils createHUDInWindowOfView:self.view];
    _HUD.userInteractionEnabled = NO;
    _HUD.dimBackground = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@?id=%lld", OSCAPI_PREFIX, OSCAPI_TWEET_DETAIL, _tweetID]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
             ONOXMLElement *tweetDetailsXML = [responseObject.rootElement firstChildWithTag:@"tweet"];
             
             _tweet = [[OSCTweet alloc] initWithXML:tweetDetailsXML];
             self.objectAuthorID = _tweet.authorID;
             _tweet.body = [NSString stringWithFormat:@"<style>a{color:#087221; text-decoration:none;}</style>\
                            <font size=\"3\"><strong>%@</strong></font>\
                            <br/><a href='%@'><img style='max-width:300px;' src='%@'/></a>",
                            _tweet.body,  _tweet.bigImgURL, _tweet.bigImgURL];
             

             [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                   withRowAnimation:UITableViewRowAnimationNone];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [_HUD hide:YES];
         }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_HUD hide:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0? 0 : 35;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        NSString *title;
        if (self.tweet.commentCount) {
            title = [NSString stringWithFormat:@"%d 条评论", self.allCount];
        } else {
            title = @"没有评论";
        }
        return title;
    }
}

#pragma mark -UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_isLoadingFinished) {
        [_HUD hide:YES];
        return;
    }
    _webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    //设置为已经加载完成
    _isLoadingFinished = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [Utils analysis:[request.URL absoluteString] andNavController:self.navigationController];
    return [request.URL.absoluteString isEqualToString:@"about:blank"];
}

@end
