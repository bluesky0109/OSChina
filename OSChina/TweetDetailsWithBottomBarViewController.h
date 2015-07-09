//
//  TweetDetailsWithBottomBarViewController.h
//  OSChina
//
//  Created by sky on 15/7/9.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "BottomBarViewController.h"

@class OSCTweet;

@interface TweetDetailsWithBottomBarViewController : BottomBarViewController

- (instancetype)initWithTweet:(OSCTweet *)tweet;

@end
