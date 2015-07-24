//
//  TeamActivityViewController.m
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamActivityViewController.h"
#import "TeamAPI.h"
#import "TeamActivity.h"
#import "TeamActivityCell.h"

#import <TTTAttributedLabel.h>

static NSString * const kActivityCellID = @"TeamActivityCell";

@interface TeamActivityViewController ()

@end

@implementation TeamActivityViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?teamid=12375&type=all&pageIndex=%lu", TEAM_PREFIX, TEAM_ACTIVITY_LIST, (unsigned long)page];
        };

        self.objClass = [TeamActivity class];
        self.needCache = YES;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"团队动态";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kActivityCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"actives"] childrenWithTag:@"active"];

}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        TeamActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kActivityCellID forIndexPath:indexPath];
        TeamActivity *activity = self.objects[indexPath.row];
        
        [cell setContentWithActivity:activity];
        
        return cell;
    } else {
        return self.lastCell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        TeamActivity *activity = self.objects[indexPath.row];
        
        self.label.attributedText = activity.attributedTittle;
        
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.bounds.size.width - 60, MAXFLOAT)].height;
        
        return height + 63;
    } else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
