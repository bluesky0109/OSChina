//
//  NewsViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"

#import "OSCNews.h"



static NSString *kNewsCellID = @"NewsCell";


@interface NewsViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation NewsViewController

- (instancetype)initWithCatalog:(int)catalog {
    self = [super init];
    if (self) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?catalog=%d&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_NEWS_LIST, catalog, (unsigned long)page, OSCAPI_SUFFIX];
        };

        self.parseXML = ^NSArray * (ONOXMLDocument *xml) {
            return [[xml.rootElement firstChildWithTag:@"newslist"] childrenWithTag:@"news"];
        };
        
        self.objClass = [OSCNews class];
        self.label = [UILabel new];
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if 1
    self.generateURL = ^NSString * (NSUInteger page) {
        NSString *url = [NSString stringWithFormat:@"%@%@?catalog=%d&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_NEWS_LIST, 1, (unsigned long)page, OSCAPI_SUFFIX];
        
        return url;
    };
    
    self.parseXML = ^NSArray * (ONOXMLDocument *xml) {
        return [[xml.rootElement firstChildWithTag:@"newslist"] childrenWithTag:@"news"];
    };
    
    self.objClass = [OSCNews class];

#endif
    
    // tableView设置
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:kNewsCellID];
    
    self.label = [UILabel new];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellID forIndexPath:indexPath];
        
        OSCNews *news = [self.objects objectAtIndex:indexPath.row];
        cell.titleLabel.text = news.title;
        cell.authorLabel.text = news.author;
        cell.timeLabel.text = [Utils intervalSinceNow:news.pubDate];
        cell.commentCount.text = @(news.commentCount).stringValue;
        
        return cell;
    } else {
        return self.lastCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        OSCNews *news = [self.objects objectAtIndex:indexPath.row];
        [self.label setText:news.title];
        
        CGSize size = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)];
        
        return size.height + 32;
    } else {
        return 60;
    }
}

@end
