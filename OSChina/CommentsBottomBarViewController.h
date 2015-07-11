//
//  CommentsBottomBarViewController.h
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "BottomBarViewController.h"
#import "CommentsViewController.h"

@interface CommentsBottomBarViewController : BottomBarViewController

- (instancetype)initWithCommentType:(CommentType)commentType andObjectID:(int64_t)objectID;

@end
