//
//  CommentsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(int, CommentsType)
{
    CommentsTypeNews = 1,
    CommentsTypePost,
    CommentsTypeTweet,
    CommentsTypeMessageCenter
};

@interface CommentsViewController : OSCObjsViewController

- (instancetype)initWithCommentsType:(CommentsType)type andID:(int64_t)objectID;

@property (nonatomic, copy) UITableViewCell *(^otherSectionCell)(NSIndexPath *indexPath);
@property (nonatomic, copy) CGFloat (^heightForOtherSectionCell)(NSIndexPath *indexPath);

@end
