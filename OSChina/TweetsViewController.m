//
//  TweetsViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-14.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "TweetsViewController.h"

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "OSCTweet.h"
#import "TweetCell.h"
#import "Utils.h"
#import "OSCAPI.h"
#import "LastCell.h"


static NSString *kTweetCellID = @"TweetCell";



#pragma mark -

@interface TweetsViewController ()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL DidFinishLoad;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) LastCell *lastCell;

@end

#pragma mark -



@implementation TweetsViewController

/*! Primary view has been loaded for this view controller
 
 */



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最新动弹";
    
    self.tweets = [NSMutableArray new];
    //NSLog(@"self.tweets的应用计数:%ld", CFGetRetainCount((__bridge CFTypeRef)self.tweets));
    //NSLog(@"self.tweets的应用计数:%ld", CFGetRetainCount((__bridge CFTypeRef)_tweets));
    
    // tableView设置
    [self.tableView registerClass:[TweetCell class] forCellReuseIdentifier:kTweetCellID];
    
    self.tableView.backgroundColor = [UIColor themeColor];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    
    // 刷新
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
    // 用于计算高度
    self.label = [UILabel new];
    
    self.lastCell = [[LastCell alloc] initCell];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.tweets.count > 0 || self.DidFinishLoad) {
        return;
    }
    
    [self fetchTweetOnPage:0 refresh:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.tweets.count) {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID forIndexPath:indexPath];
        OSCTweet *tweet = [self.tweets objectAtIndex:indexPath.row];
        
        [cell.portrait sd_setImageWithURL:tweet.portraitURL placeholderImage:nil options:0]; //options:SDWebImageRefreshCached
        [cell.portrait setCornerRadius:5.0];
        
        [cell.authorLabel setText:tweet.author];
        [cell.timeLabel setText:[Utils intervalSinceNow:tweet.pubDate]];
        [cell.appclientLabel setText:[Utils getAppclient:tweet.appclient]];
        [cell.commentCount setText:[NSString stringWithFormat:@"评论：%d", tweet.commentCount]];
        
        [cell.contentLabel setText:tweet.body];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.tweets.count) {
        OSCTweet *tweet = [self.tweets objectAtIndex:indexPath.row];
        [self.label setText:tweet.body];
        self.label.numberOfLines = 0;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGSize size = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)];
        
        return size.height + 71;
    } else {
        return 60;
    }
}


#pragma mark - 刷新
- (void)refresh
{
    static BOOL refreshInProgress = NO;
    
    if (!refreshInProgress)
    {
        refreshInProgress = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchTweetOnPage:0 refresh:YES];
            refreshInProgress = NO;
        });
    }
}


#pragma mark - 上拉加载更多
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        [self fetchTweetOnPage:(self.tweets.count + 19)/20 refresh:NO];
    }
}


#pragma mark - 加载动弹

- (void)fetchTweetOnPage:(NSUInteger)page refresh:(BOOL)refresh
{
#if 0
    if (![Tools isNetworkExist]) {
        if (refresh) {
            [self.refreshControl endRefreshing];
        } else {
            _isLoading = NO;
            if (_isFinishedLoad) {
                [_lastCell finishedLoad];
            } else {
                [_lastCell normal];
            }
        }
        [Tools toastNotification:@"网络连接失败，请检查网络设置" inView:self.parentViewController.view];
        return;
    }
#endif
    
    if (!refresh) {[_lastCell loading];}
    
    NSString *url = [NSString stringWithFormat:@"%@%@?uid=0&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_TWEETS_LIST, (unsigned long)page, OSCAPI_SUFFIX];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
             NSArray *tweetsXML = [[responseDocument.rootElement firstChildWithTag:@"tweets"] childrenWithTag:@"tweet"];
             self.DidFinishLoad = tweetsXML.count < 20;
             
             if (refresh) {
                 [self.refreshControl endRefreshing];
                 [self.tweets removeAllObjects];
             }
             
             for (ONOXMLElement *tweetXML in tweetsXML) {
                 OSCTweet *tweet = [[OSCTweet alloc] initWithXML:tweetXML];
                 [self.tweets addObject:tweet];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
                 self.DidFinishLoad? [self.lastCell finishedLoad]: [self.lastCell normal];
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"网络异常，错误码：%ld", (long)error.code);
         }
     ];
}




@end
