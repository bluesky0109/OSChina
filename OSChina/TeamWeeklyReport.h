//
//  TeamWeeklyReport.h
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"
#import "TeamMember.h"

@interface TeamWeeklyReport : OSCBaseObject

@property (nonatomic, assign) int        reportID;
@property (nonatomic, copy  ) NSString   *title;
@property (nonatomic, assign) int        replyCount;
@property (nonatomic, copy  ) NSString   *createTime;
@property (nonatomic, strong) TeamMember *author;
@property (nonatomic, strong) NSMutableAttributedString *attributedTitle;

@end
