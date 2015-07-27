//
//  WeeklyReportTableViewController.m
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "WeeklyReportTableViewController.h"
#import "TeamAPI.h"
#import "TeamWeeklyReport.h"
#import "WeeklyReportCell.h"

static NSString * const kWeeklyReportCellID = @"WeeklyReportCell";

@interface WeeklyReportTableViewController ()

@end

@implementation WeeklyReportTableViewController

- (instancetype)initWithTeamID:(int)teamID year:(NSInteger)year andWeek:(NSInteger)week {
    if (self = [super init]) {
        _year = year;
        _week = week;
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?teamid=%d&year=%ld&week=%ld&pageIndex=%lu", TEAM_PREFIX, TEAM_DIARY_LIST, teamID, year, week, (unsigned long)page];
        };
        
        self.objClass = [TeamWeeklyReport class];
        self.needCache = YES;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[WeeklyReportCell class] forCellReuseIdentifier:kWeeklyReportCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"diaries"] childrenWithTag:@"diary"];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        WeeklyReportCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeeklyReportCellID forIndexPath:indexPath];
        TeamWeeklyReport *weeklyReport = self.objects[indexPath.row];
        
        [cell setContentWithWeeklyReport:weeklyReport];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        TeamWeeklyReport *weeklyReport = self.objects[indexPath.row];
        
        self.label.attributedText = weeklyReport.attributedTitle;
        
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.bounds.size.width - 60, MAXFLOAT)].height;
        
        return height + 63;
    } else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
