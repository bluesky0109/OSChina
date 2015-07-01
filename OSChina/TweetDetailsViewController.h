//
//  TweetDetailsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "CommentsViewController.h"

@class OSCTweet;

@interface TweetDetailsViewController : CommentsViewController

- (instancetype)initWithTweet:(OSCTweet *)tweet;

@end
