//
//  TeamDiscussion.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"
#import "TeamMember.h"

@interface TeamDiscussion : OSCBaseObject

@property (nonatomic, assign) int        discussionID;
@property (nonatomic, copy  ) NSString   *type;
@property (nonatomic, copy  ) NSString   *title;
@property (nonatomic, copy  ) NSString   *body;
@property (nonatomic, copy  ) NSString   *createTime;
@property (nonatomic, assign) int        answerCount;
@property (nonatomic, assign) int        voteUpCount;
@property (nonatomic, strong) TeamMember *author;

@end
