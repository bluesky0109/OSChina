//
//  PostsViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "PostsViewController.h"
#import "DetailsViewController.h"
#import "PostsCell.h"
#import "OSCPost.h"
#import "UIImageView+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *kPostCellID = @"PostCell";


@interface PostsViewController ()

@end

@implementation PostsViewController

- (instancetype)initWithPostsType:(PostsType)type {
    self = [super init];
    if (self) {
        self.generateURL = ^NSString *(NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?catalog=%d&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_POSTS_LIST, type, (unsigned long)page, OSCAPI_SUFFIX];
        };
        
        self.objClass = [OSCPost class];
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PostsCell class] forCellReuseIdentifier:kPostCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"posts"] childrenWithTag:@"post"];
}

#pragma mark -- UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        PostsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPostCellID forIndexPath:indexPath];
        OSCPost *post = self.objects[indexPath.row];
        
        [cell.portrait loadPortrait:post.portraitURL];
        [cell.titleLabel setText:post.title];
        [cell.bodyLabel setText:post.body];
        [cell.authorLabel setText:post.author];
        [cell.timeLabel setText:[Utils intervalSinceNow:post.pubDate]];
        [cell.commentAndView setText:[NSString stringWithFormat:@"%d回 / %d阅", post.replyCount, post.viewCount]];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        OSCPost *post = self.objects[indexPath.row];
        
        self.label.text = post.title;
        self.label.font = [UIFont boldSystemFontOfSize:15];
        
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 62, MAXFLOAT)].height;
        
        self.label.text = post.body;
        self.label.font = [UIFont systemFontOfSize:13];
        height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 62, MAXFLOAT)].height;
        
        return height + 41;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    if (row < self.objects.count) {
        OSCPost *post = self.objects[row];
        DetailsViewController *detailsVC = [[DetailsViewController alloc] initWithPost:post];
        [self.navigationController pushViewController:detailsVC animated:YES];
    } else {
        [self fetchMore];
    }
}

@end
