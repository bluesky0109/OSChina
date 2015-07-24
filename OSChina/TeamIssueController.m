//
//  TeamIssueController.m
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamIssueController.h"
#import "TeamAPI.h"
#import "TeamIssue.h"
#import "TeamIssueCell.h"
#import "Utils.h"

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>

static NSString * const kIssueCellID = @"IssueCell";

@interface TeamIssueController ()

@end

@implementation TeamIssueController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?teamid=12375&project=-1&pageIndex=%lu", TEAM_PREFIX, TEAM_ISSUE_LIST, (unsigned long)page];
        };
        
        self.objClass = [TeamIssue class];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TeamIssueCell class] forCellReuseIdentifier:kIssueCellID];
    self.tableView.backgroundColor = [UIColor themeColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"issues"] childrenWithTag:@"issue"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        TeamIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:kIssueCellID forIndexPath:indexPath];
        TeamIssue *issue = self.objects[indexPath.row];
        
        [cell setContentWithissue:issue];
        
        return cell;
    } else {
        return self.lastCell;
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        UILabel *label = [UILabel new];
        TeamIssue *issue = self.objects[indexPath.row];

        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = issue.title;

        CGFloat height = [label sizeThatFits:CGSizeMake(tableView.bounds.size.width - 16, MAXFLOAT)].height;
        
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
