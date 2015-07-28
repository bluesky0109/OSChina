//
//  TeamIssueListViewController.m
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamIssueListViewController.h"
#import "TeamIssueController.h"
#import "Config.h"
#import "TeamAPI.h"
#import "TeamIssueListCell.h"
#import "TeamIssueList.h"
static NSString *kTeamIssueListCellID = @"teamIssueListCell";

@interface TeamIssueListViewController ()

@property (nonatomic, assign) int      projectId;
@property (nonatomic, assign) int      teamId;
@property (nonatomic, copy  ) NSString *source;

@end

@implementation TeamIssueListViewController

- (instancetype)initWithTeamId:(int)teamId projectId:(int)projectId source:(NSString *)source
{
    if (self = [super init]) {
        self.projectId = projectId;
        self.teamId = teamId;
        self.source = source;
        self.generateURL = ^NSString * (NSUInteger page) {
            NSString *url = [NSString stringWithFormat:@"%@%@?uid=%lld&teamid=%d&projectid=%d&source=%@", OSCAPI_PREFIX, TEAM_PROJECT_CATALOG_LIST,[Config getOwnID],teamId,projectId,source];
            return url;
        };
        
        __weak typeof(self) weakSelf = self;
        self.tableWillReload = ^(NSUInteger responseObjectsCount) {
            [weakSelf.lastCell statusFinished];
        };
        
        self.objClass = [TeamIssueList class];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TeamIssueListCell class] forCellReuseIdentifier:kTeamIssueListCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    return [[xml.rootElement firstChildWithTag:@"catalogs"] childrenWithTag:@"catalog"];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        TeamIssueListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTeamIssueListCellID forIndexPath:indexPath];
        TeamIssueList *list = self.objects[indexPath.row];
        
        [cell.titleLabel setText:list.listTitle];
        [cell.detailLabel setText:[list.listDescription length]<=0?@"暂无描述":list.listDescription];
        [cell.countLabel setText:[NSString stringWithFormat:@"%d/%d",list.openedIssueCount,list.allIssueCount]];
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        return 52;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.objects.count) {
        TeamIssueList *list = self.objects[indexPath.row];
        TeamIssueController * issueVc = [[TeamIssueController alloc] initWithTeamId:_teamId ProjectId:_projectId userId:[Config getOwnID] source:_source catalogId:list.teamIssueId];
        [self.navigationController pushViewController:issueVc animated:YES];
    }else {
        [self fetchMore];
    }
}



@end
