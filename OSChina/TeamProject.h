//
//  TeamProject.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface TeamProject : OSCBaseObject

@property (nonatomic, assign) int      projectID;
@property (nonatomic, copy  ) NSString *source;
@property (nonatomic, assign) int      teamID;

@property (nonatomic, assign) int      gitID;
@property (nonatomic, copy  ) NSString *projectName;
@property (nonatomic, copy  ) NSString *projectPath;
@property (nonatomic, copy  ) NSString *ownerName;
@property (nonatomic, copy  ) NSString *ownerUserName;

@property (nonatomic, assign) int      openedIssueCount;
@property (nonatomic, assign) int      allIssueCount;
@property (nonatomic, assign) BOOL     gitPush;

- (NSAttributedString *)attributedTittle;

@end
