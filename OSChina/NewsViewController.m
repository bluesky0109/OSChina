//
//  NewsViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "NewsViewController.h"
#import "DetailsViewController.h"
#import "NewsCell.h"
#import "OSCNews.h"



static NSString *kNewsCellID = @"NewsCell";


@interface NewsViewController ()

@end

@implementation NewsViewController

- (instancetype)initWithNewsListType:(NewsListType)type {
    self = [super init];
    if (self) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?catalog=%d&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_NEWS_LIST, type, (unsigned long)page, OSCAPI_SUFFIX];
        };

        self.parseXML = ^NSArray * (ONOXMLDocument *xml) {
            return [[xml.rootElement firstChildWithTag:@"newslist"] childrenWithTag:@"news"];
        };
        
        self.objClass = [OSCNews class];
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView设置
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:kNewsCellID];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellID forIndexPath:indexPath];
        OSCNews *news = [self.objects objectAtIndex:indexPath.row];
        
        [cell.titleLabel setText:news.title];
        [cell.authorLabel setText:news.author];
        [cell.timeLabel setText:[Utils intervalSinceNow:news.pubDate]];
        [cell.commentCount setText:[NSString stringWithFormat:@"%d 评", news.commentCount]];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        OSCNews *news = [self.objects objectAtIndex:indexPath.row];
        [self.label setText:news.title];
        
        CGSize size = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)];
        
        return size.height + 39;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCNews *news = [self.objects objectAtIndex:row];
        DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithNews:news];
        [self.navigationController pushViewController:detailsViewController animated:YES];
    } else {
        [self fetchMore];
    }
}


@end
