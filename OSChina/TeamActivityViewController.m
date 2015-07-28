//
//  TeamActivityViewController.m
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamActivityViewController.h"
#import "TeamActivityDetailViewController.h"
#import "TeamAPI.h"
#import "TeamActivity.h"
#import "TeamActivityCell.h"

#import <TTTAttributedLabel.h>

static NSString * const kActivityCellID = @"TeamActivityCell";

@interface TeamActivityViewController ()

@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic,assign)int teamId;

@end

@implementation TeamActivityViewController

- (instancetype)initWithTeamID:(int)teamID
{
    if (self = [super init]) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?teamid=%d&type=all&pageIndex=%lu", TEAM_PREFIX, TEAM_ACTIVITY_LIST, teamID, (unsigned long)page];
        };
        
        self.objClass = [TeamActivity class];
        self.needCache = YES;
    }
    
    return self;
}

#pragma mark --某个团队项目的动态
//teamid 团队id
//projectid 项目id
//source "Git@OSC"(default),"GitHub"
//type "all"(default),"issue","code","other"
//pageIndex 页数
//pageSize 每页条数
- (instancetype)initWithTeamId:(int)teamId projectId:(int)projectId
{
    if (self = [super init]) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?teamid=%d&projectid=%d&source=Git@OSC&type=all&pageIndex=%lu&pageSize=20", TEAM_PREFIX, TEAM_PROJECT_ACTIVE_LIST,teamId,projectId, (unsigned long)page];
        };
        self.teamId = teamId;
        self.objClass = [TeamActivity class];
        self.needCache = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"团队动态";
    
    [self.tableView registerClass:[TeamActivityCell class] forCellReuseIdentifier:kActivityCellID];
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
        
        self.label.attributedText = activity.attributedTitle;
        
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.bounds.size.width - 60, MAXFLOAT)].height;
        
        return height + 63;
    } else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.objects.count) {
        TeamActivity *selectedActivity = self.objects[indexPath.row];
        TeamActivityDetailViewController *detailVC = [TeamActivityDetailViewController new];
        detailVC.activityID = selectedActivity.activityID;
        detailVC.teamID = _teamId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else {
        [self fetchMore];
    }
    
}

@end
