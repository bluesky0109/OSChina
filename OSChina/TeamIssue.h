//
//  TeamIssue.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

#import "TeamProject.h"
#import "TeamProjectAuthority.h"
#import "TeamMember.h"

@interface TeamIssue : OSCBaseObject

@property (nonatomic, assign) int                  issueID;
@property (nonatomic, copy  ) NSString             *state;
@property (nonatomic, assign) int                  stateLevel;
@property (nonatomic, copy  ) NSString             *priority;
@property (nonatomic, assign) BOOL                 gitPush;
@property (nonatomic, copy  ) NSString             *source;
@property (nonatomic, assign) int                  catalogID;
@property (nonatomic, copy  ) NSString             *title;
@property (nonatomic, copy  ) NSString             *issueDescription;
@property (nonatomic, copy  ) NSString             *createTime;
@property (nonatomic, copy  ) NSString             *updateTime;
@property (nonatomic, copy  ) NSString             *acceptTime;
@property (nonatomic, copy  ) NSString             *deadline;
@property (nonatomic, assign) int                  replyCount;
@property (nonatomic, strong) NSURL                *gitIssueURL;
@property (nonatomic, strong) TeamMember           *author;
@property (nonatomic, strong) TeamMember           *user;
@property (nonatomic, strong) TeamProjectAuthority *authority;


@property (nonatomic, strong) TeamProject *project;
@property (nonatomic, assign) int         childIssuesCount;
@property (nonatomic, assign) int         closedChildIssuesCount;
@property (nonatomic, assign) int         attachmentsCount;
@property (nonatomic, assign) int         relationIssueCount;

@end
