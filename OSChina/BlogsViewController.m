//
//  BlogsViewController.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "BlogsViewController.h"
#import "DetailsViewController.h"
#import "Config.h"
#import "BlogCell.h"
#import "OSCBlog.h"

static NSString *kBlogCellID = @"BlogCell";

@interface BlogsViewController ()

@end

@implementation BlogsViewController

- (instancetype)initWithBlogsType:(BlogsType)type {
    self = [super init];
    if (self) {
        NSString *blogType = type == BlogsTypeLatest? @"latest" : @"recommend";
        
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?type=%@&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_BLOGS_LIST, blogType, (unsigned long)page, OSCAPI_SUFFIX];
        };
        
        self.objClass = [OSCBlog class];
    }
    
    return self;
}

- (instancetype)initWithUserID:(int64_t)userID {
    self = [super init];
    if (self) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?authoruid=%lld&pageIndex=%lu&uid=%lld", OSCAPI_PREFIX, OSCAPI_USERBLOGS_LIST, userID, (unsigned long)page, [Config getOwnID]];
        };
        self.objClass = [OSCBlog class];
    }
    
    return self;
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    return [[xml.rootElement firstChildWithTag:@"blogs"] childrenWithTag:@"blog"];
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BlogCell class] forCellReuseIdentifier:kBlogCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        BlogCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kBlogCellID forIndexPath:indexPath];
        OSCBlog *blog = self.objects[indexPath.row];
        
        [cell.titleLabel setText:blog.title];
        [cell.bodyLabel setText:blog.body];
        [cell.authorLabel setText:blog.author];
        [cell.timeLabel setText:[Utils intervalSinceNow:blog.pubDate]];
        [cell.commentCount setText:[NSString stringWithFormat:@"%d评", blog.commentCount]];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        OSCBlog *blog = self.objects[indexPath.row];
        
        self.label.text = blog.title;
        self.label.font = [UIFont boldSystemFontOfSize:14];
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
        
        self.label.text = blog.body;
        self.label.font = [UIFont systemFontOfSize:13];
        height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
        
        return height + 41;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCBlog *blog = self.objects[row];
        DetailsViewController *detailsVC = [[DetailsViewController alloc] initWithBlog:blog];
        [self.navigationController pushViewController:detailsVC animated:YES];
    } else {
        [self fetchMore];
    }
}

@end
