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

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>

static NSString * const kActivityCellID = @"TeamActivityCell";

@interface TeamActivityViewController ()

@property (nonatomic, strong) NSMutableArray *activities;

@end

@implementation TeamActivityViewController

- (instancetype)init
{
    if (self = [super init]) {
        _activities = [NSMutableArray new];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kActivityCellID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    [manager GET:[NSString stringWithFormat:@"%@%@", TEAM_PREFIX, TEAM_ACTIVITY_LIST]
      parameters:@{
                   @"teamid": @(12375),
                   @"type": @"all"
                   }
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
             NSArray *activitiesXML = [[responseObject.rootElement firstChildWithTag:@"actives"] childrenWithTag:@"active"];
             
             for (ONOXMLElement *activityXML in activitiesXML) {
                 [_activities addObject:[[TeamActivity alloc] initWithXML:activityXML]];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kActivityCellID forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    
    if (row) {
        TeamActivity *activity = _activities[indexPath.row];
        cell.textLabel.text = activity.title;
    }
    
    return cell;
}

@end
