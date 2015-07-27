//
//  WeeklyReportTableViewController.h
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

@interface WeeklyReportTableViewController : OSCObjsViewController

@property (nonatomic, readonly, assign) NSInteger year;
@property (nonatomic, readonly, assign) NSInteger week;

- (instancetype)initWithTeamID:(int)teamID year:(NSInteger)year andWeek:(NSInteger)week;

@end
