//
//  TeamDiscussionDetails.h
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"
#import "TeamMember.h"

@interface TeamDiscussionDetails : OSCBaseObject


@property (nonatomic, assign) int        discussionID;
@property (nonatomic, copy  ) NSString   *type;
@property (nonatomic, copy  ) NSString   *title;
@property (nonatomic, copy  ) NSString   *body;
@property (nonatomic, copy  ) NSString   *createTime;
@property (nonatomic, assign) int        answerCount;
@property (nonatomic, assign) int        voteUpCount;
@property (nonatomic, strong) TeamMember *author;

@end
