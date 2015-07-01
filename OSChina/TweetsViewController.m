//
//  TweetsViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-14.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetDetailsViewController.h"

#import "OSCTweet.h"
#import "TweetCell.h"


static NSString *kTweetCellID = @"TweetCell";

#pragma mark -

@interface TweetsViewController ()

@property (nonatomic, assign) int64_t uid;

@end

#pragma mark -



@implementation TweetsViewController

/*! Primary view has been loaded for this view controller
 
 */

- (instancetype)initWithTweetsType:(TweetsType)type {
    self = [super init];
    if (self) {
        switch (type) {
            case TweetsTypeAllTweets:
                self.uid = 0;
                break;
                
            case TweetsTypeHotestTweets:
                self.uid = -1;
                break;
                
            case TweetsTypeOwnTweets:
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
        
        [cell setContentWithTweet:tweet];
        
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
        
        CGSize size = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)];
        
        return size.height + 65;
    } else {
        return 60;
    }
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCTweet *tweet = [self.objects objectAtIndex:row];
        
        TweetDetailsViewController *tweetDetailsVC = [[TweetDetailsViewController alloc] initWithTweet:tweet];
        
        NSLog(@"%@", self.parentViewController);
        NSLog(@"%@", self.parentViewController.navigationController);
        NSLog(@"%@", self.navigationController);
        NSLog(@"%@", self.parentViewController.parentViewController);
        NSLog(@"%@", self.parentViewController.parentViewController.navigationController);
        
        [self.navigationController pushViewController:tweetDetailsVC animated:YES];
        
    } else {
        [self fetchMore];
    }
}


@end
