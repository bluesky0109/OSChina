//
//  TeamIssueDetailController.m
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamIssueDetailController.h"

@interface TeamIssueDetailController ()

@end

@implementation TeamIssueDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kTeamIssueDetailCell = @"teamIssueDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTeamIssueDetailCell];          if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier: kTeamIssueDetailCell];
    }
    
    
    cell.imageView.image = [UIImage imageNamed:@"me-blog"];
    cell.textLabel.text = @"处理听云上面收集到的奔溃bug";
    cell.detailTextLabel.text = @"未指定截止日";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    if(indexPath.row == 0)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lineView];
        
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(lineView);
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(0.5)]|"
                                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                                 metrics:nil
                                                                                   views:views]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[lineView]-20-|"
                                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                                 metrics:nil
                                                                                   views:views]];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return @"开源中国";
    }else {
        return nil;
    }
}

@end
