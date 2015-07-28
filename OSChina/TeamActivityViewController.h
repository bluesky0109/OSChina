//
//  TeamActivityViewController.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

@interface TeamActivityViewController : OSCObjsViewController

- (instancetype)initWithTeamID:(int)teamID;
- (instancetype)initWithTeamId:(int)teamId projectId:(int)projectId;

@end
