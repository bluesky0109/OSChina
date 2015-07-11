//
//  ActivitiesViewController.m
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "OSCActivity.h"
#import "ActivityCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const kActivityCellID = @"ActivityCell";

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

- (instancetype)initWithUID:(int64_t)userID {
    self = [super init];
    
    if (self) {
        self.generateURL = ^NSString *(NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?uid=%lld&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_EVENT_LIST, userID, page, OSCAPI_SUFFIX];
        };
        
        self.objClass = [OSCActivity class];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ActivityCell class] forCellReuseIdentifier:kActivityCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"events"] childrenWithTag:@"event"];
}

#pragma mark -UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kActivityCellID forIndexPath:indexPath];
        
        OSCActivity *activity = self.objects[indexPath.row];
        
        cell.titleLabel.text       = activity.title;
        cell.descriptionLabel.text = [NSString stringWithFormat:@"时间：%@\n地点：%@", activity.startTime, activity.location];
        [cell.posterView sd_setImageWithURL:activity.coverURL placeholderImage:nil];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        OSCActivity *activity = self.objects[indexPath.row];
        
        self.label.text = activity.title;
        self.label.font = [UIFont boldSystemFontOfSize:14];
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 64, MAXFLOAT)].height;
        
        self.label.text = [NSString stringWithFormat:@"时间：%@\n地点：%@", activity.startTime, activity.location];
        self.label.font = [UIFont systemFontOfSize:13];
        height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 64, MAXFLOAT)].height;
        
        return height + 26;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCActivity *activity = self.objects[indexPath.row];
        //DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithNews:news];
        //[self.navigationController pushViewController:detailsViewController animated:YES];
    } else {
        [self fetchMore];
    }
}

@end
