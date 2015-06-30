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

static NSString *kTweetCellID = @"TweetCell";

#pragma mark -

@interface TweetsViewController ()

@property (nonatomic, assign) int64_t uid;

@property (nonatomic, strong) UILabel *label;

@end

#pragma mark -



@implementation TweetsViewController

/*! Primary view has been loaded for this view controller
 
 */

- (instancetype)initWithTweetsType:(TweetsType)tweetsType {
    self = [super init];
    if (self) {
        switch (tweetsType) {
            case AllTweets:
                self.uid = 0;
                break;
                
            case HotestTweets:
                self.uid = -1;
                break;
                
            case OwnTweets:
                self.uid = 1244649;
                
            default:
                break;
        }
        
        __weak TweetsViewController *weakSelf = self;
        self.tableWillReload = ^(NSUInteger responseObjectsCount) {
            if (weakSelf.uid == -1) {
                [weakSelf.lastCell statusFinished];
            } else {
                responseObjectsCount < 20? [weakSelf.lastCell statusFinished]: [weakSelf.lastCell statusMore];
            }
        };
        
        self.generateURL = ^(NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?uid=%lld&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_TWEETS_LIST, weakSelf.uid, (unsigned long)page, OSCAPI_SUFFIX];
        };
        
        self.parseXML = ^NSArray * (ONOXMLDocument *xml) {
            return [[xml.rootElement firstChildWithTag:@"tweets"] childrenWithTag:@"tweet"];
        };
        
        self.objClass = [OSCTweet class];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView设置
    [self.tableView registerClass:[TweetCell class] forCellReuseIdentifier:kTweetCellID];
    
    // 用于计算高度
    self.label = [UILabel new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID forIndexPath:indexPath];
        OSCTweet *tweet = [self.objects objectAtIndex:indexPath.row];
        
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
    if (indexPath.row < self.objects.count) {
        OSCTweet *tweet = [self.objects objectAtIndex:indexPath.row];
        [self.label setText:tweet.body];
        self.label.numberOfLines = 0;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGSize size = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)];
        
        return size.height + 71;
    } else {
        return 60;
    }
}

@end
