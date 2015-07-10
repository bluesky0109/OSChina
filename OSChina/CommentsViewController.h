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
    CommentTypeMessageCenter
};

@interface CommentsViewController : OSCObjsViewController

@property (nonatomic, assign, readwrite) int64_t objectAuthorID;

@property (nonatomic, copy) UITableViewCell *(^otherSectionCell)(NSIndexPath *indexPath);
@property (nonatomic, copy) CGFloat (^heightForOtherSectionCell)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didCommentSelected)(NSString *authorName);
@property (nonatomic, copy) void (^didScroll)();

- (instancetype)initWithCommentType:(CommentType)type andObjectID:(int64_t)objectID;

@end
