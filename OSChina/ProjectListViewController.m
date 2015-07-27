//
//  ProjectListViewController.m
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "ProjectListViewController.h"
#import "Config.h"
#import "ProjectCell.h"
#import "TeamAPI.h"
#import "TeamProject.h"
#import "SwipableViewController.h"
#import "TeamIssueListViewController.h"
#import "TeamMemberViewController.h"
#import "TeamActivityViewController.h"

static NSString *kProjectCellID = @"ProjectCell";

@interface ProjectListViewController ()

@end

@implementation ProjectListViewController

- (instancetype)init {
    if (self = [super init]) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?teamid=12375", OSCAPI_PREFIX, TEAM_PROJECT_LIST];
        };
        
        __weak typeof(self) weakSelf = self;
        self.tableWillReload = ^(NSUInteger responseObjectsCount) {
            [weakSelf.lastCell statusFinished];
            
        };
        
        self.objClass = [TeamProject class];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ProjectCell class] forCellReuseIdentifier:kProjectCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"projects"] childrenWithTag:@"project"];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        ProjectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kProjectCellID forIndexPath:indexPath];
        TeamProject *project = self.objects[indexPath.row];
        
        [cell.titleLabel setAttributedText:project.attributedTittle];
        [cell.countLabel setText:[NSString stringWithFormat:@"%d/%d",project.openedIssueCount,project.allIssueCount]];
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        
        
        self.label.font = [UIFont boldSystemFontOfSize:15];
        
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
        
        
        self.label.font = [UIFont systemFontOfSize:13];
        height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
        
        return height + 42;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamProject *project = self.objects[indexPath.row];
    
    SwipableViewController *teamProjectSVC = [[SwipableViewController alloc]
                                              initWithTitle:@"团队项目"
                                              andSubTitles:@[@"任务分组", @"动态", @"成员"]
                                              andControllers:@[             [[TeamIssueListViewController alloc] initWithProjectId:project.projectID source:project.source],[[TeamActivityViewController alloc]  initWithProjectId:project.gitID],[[TeamMemberViewController alloc] init]]
                                              underTabbar:NO];
    
    [self.navigationController pushViewController:teamProjectSVC animated:YES];
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSInteger row = indexPath.row;
    //
    //    if (row < self.objects.count) {
    //        OSCBlog *blog = self.objects[row];
    //        DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithBlog:blog];
    //        [self.navigationController pushViewController:detailsViewController animated:YES];
    //    } else {
    //        [self fetchMore];
    //    }
}


@end
