//
//  WeeklyReportContentViewController.m
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "WeeklyReportContentViewController.h"
#import "WeeklyReportTableViewController.h"
#import "Utils.h"

@interface WeeklyReportContentViewController ()

@property (nonatomic, assign) int teamID;
@property (nonatomic, strong) NSMutableArray *vcs;

@end

@implementation WeeklyReportContentViewController

- (instancetype)initWithTeamID:(int)teamID
{
    _teamID = teamID;
    
    NSDate *date = [NSDate date];
    NSDateComponents *dateComps = [Utils getDateComponentsFromDate:date];
    
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 1; i >= 0; i--) {
        WeeklyReportTableViewController *vc = [[WeeklyReportTableViewController alloc] initWithTeamID:teamID
                                                                                                 year:dateComps.year
                                                                                              andWeek:dateComps.weekOfYear - i];
        [controllers addObject:vc];
    }
    
    return [super initWithViewControllers:controllers];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < 0) {
        WeeklyReportTableViewController *firstVC = self.controllers[0];
        WeeklyReportTableViewController *vc = [[WeeklyReportTableViewController alloc] initWithTeamID:_teamID
                                                                                                 year:firstVC.year
                                                                                              andWeek:firstVC.week - 1];
        [self.controllers insertObject:vc atIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            [self scrollToViewAtIndex:0];
        });
    }
}

@end
