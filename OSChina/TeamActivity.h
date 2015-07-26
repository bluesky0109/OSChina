//
//  TeamActivity.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"
@class TeamMember;

@interface TeamActivity : OSCBaseObject

@property (nonatomic, assign) int        activityID;
@property (nonatomic, assign) int        type;
@property (nonatomic, assign) int        appID;
@property (nonatomic, copy  ) NSString   *appName;

@property (nonatomic, copy  ) NSString   *title;
@property (nonatomic, copy  ) NSString   *detail;
@property (nonatomic, copy  ) NSString   *code;
@property (nonatomic, copy  ) NSString   *codeType;
@property (nonatomic, strong) NSURL      *imageURL;
@property (nonatomic, strong) NSURL      *originImageURL;
@property (nonatomic, assign) int        replyCount;
@property (nonatomic, copy  ) NSString   *createTime;
@property (nonatomic, strong) TeamMember *author;

@property (nonatomic, strong) NSMutableAttributedString *attributedTitle;

@end
