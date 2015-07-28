//
//  TeamWeeklyReportDetail.h
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"
#import "TeamMember.h"

@interface TeamWeeklyReportDetail : OSCBaseObject

@property (nonatomic, assign) int                reportID;
@property (nonatomic, copy  ) NSString           *title;
@property (nonatomic, assign) int                replyCount;
@property (nonatomic, copy  ) NSString           *createTime;

@property (nonatomic, strong) TeamMember         *author;
@property (nonatomic, copy  ) NSAttributedString *summary;
@property (nonatomic, strong) NSArray            *details;
@property (nonatomic, assign) int                days;

@end
