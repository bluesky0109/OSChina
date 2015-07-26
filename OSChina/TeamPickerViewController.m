//
//  TeamPickerViewController.m
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamPickerViewController.h"
#import "TeamTeam.h"

static NSString * kTeamCellID = @"TeamCell";

@interface TeamPickerViewController ()

@property (nonatomic, strong) NSArray *teams;

@end

@implementation TeamPickerViewController
- (instancetype)initWithTeams:(NSArray *)teams
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _teams = teams;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTeamCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _teams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTeamCellID forIndexPath:indexPath];
    
    cell.textLabel.text = ((TeamTeam *)_teams[indexPath.row]).name;
    
    return cell;
}

@end
