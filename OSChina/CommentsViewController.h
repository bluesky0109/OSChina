//
//  CommentsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(int, CommentType)
{
    CommentTypeNews = 1,
    CommentTypePost,
    CommentTypeTweet,
    CommentTypeMessageCenter,
    
    CommentTypeBlog,
    CommentTypeSoftware
};

@class OSCComment;

@interface CommentsViewController : OSCObjsViewController

@property (nonatomic, assign, readwrite) int64_t objectAuthorID;

@property (nonatomic, copy) UITableViewCell *(^otherSectionCell)(NSIndexPath *indexPath);
@property (nonatomic, copy) CGFloat (^heightForOtherSectionCell)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didCommentSelected)(OSCComment *comment);
@property (nonatomic, copy) void (^didScroll)();

- (instancetype)initWithCommentType:(CommentType)commentType andObjectID:(int64_t)objectID;

@end
