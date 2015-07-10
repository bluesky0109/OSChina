//
//  TweetDetailsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "CommentsViewController.h"

@interface TweetDetailsViewController : CommentsViewController

- (instancetype)initWithTweetID:(int64_t)tweetID;

@end
