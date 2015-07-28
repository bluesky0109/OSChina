//
//  TeamIssueController.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//


#import "OSCObjsViewController.h"
@interface TeamIssueController : OSCObjsViewController

- (instancetype)initWithTeamId:(int)teamId ProjectId:(int)projectId userId:(int64_t)userId source:(NSString*)source catalogId:(int64_t)catalogId;
- (instancetype)initWithTeamID:(int)teamID;
- (void)switchToTeam:(int)teamID;

@end
