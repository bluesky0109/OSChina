//
//  SearchResultsViewController.m
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "OSCSearchResult.h"
#import "SoftwareCell.h"
#import "NewsCell.h"
#import "Utils.h"

static NSString * const kSoftwareCellID = @"SoftwareCell";
static NSString * const kNewsCellID     = @"NewsCell";
static NSString * const kBlogCellID     = @"BlogCell";
static NSString * const kPostCellID     = @"PostCell";

static NSString * const kSoftware       = @"software";

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

- (instancetype)initWithType:(NSString *)type {
    self = [super init];
    if (!self) {return nil;}
    
    _keyword = @"";
    
    __weak SearchResultsViewController *weakSelf = self;
    self.generateURL = ^NSString * (NSUInteger page) {
        NSString *keyword = [weakSelf.keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"%@%@?catalog=%@&content=%@&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_SEARCH_LIST, type, keyword, (unsigned long)page, OSCAPI_SUFFIX];
    };
    
    self.objClass = [OSCSearchResult class];
    self.needRefreshAnimation = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"results"] childrenWithTag:@"result"];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCSearchResult *result = self.objects[row];
        UITableViewCell *cell = [self createCellWithSearchResult:result];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [self heightForRowAtIndexPath:indexPath];
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCSearchResult *result = self.objects[indexPath.row];
        [Utils analysis:result.url andNavController:self.navigationController];
    } else {
        [self fetchMore];
    }
}

- (UITableViewCell *)createCellWithSearchResult:(OSCSearchResult *)result {
    if ([result.type isEqualToString:kSoftware]) {
        SoftwareCell *cell = [SoftwareCell new];
        cell.nameLabel.text = result.title;
        cell.descriptionLabel.text = result.objectDescription;
        
        return cell;
    } else {
        NewsCell *cell = [NewsCell new];
        cell.titleLabel.text  = result.title;
        cell.authorLabel.text = result.author;
        cell.bodyLabel.text   = result.objectDescription;
        cell.timeLabel.text   = [Utils intervalSinceNow:result.pubDate];
        
        return cell;
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OSCSearchResult *result = self.objects[indexPath.row];
    
    self.label.font = [UIFont systemFontOfSize:15];
    [self.label setText:result.title];
    CGFloat height = [self.label sizeThatFits:CGSizeMake(self.view.frame.size.width - 16, MAXFLOAT)].height;
    
    self.label.text = result.objectDescription;
    self.label.font = [UIFont systemFontOfSize:13];
    height += [self.label sizeThatFits:CGSizeMake(self.tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    return height + ([result.type isEqualToString:kSoftware]? 21: 42);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.viewDidScroll) {
        self.viewDidScroll();
    }
}


@end
