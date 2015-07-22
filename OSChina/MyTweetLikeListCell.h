//
//  MyTweetLikeListCell.h
//  OSChina
//
//  Created by sky on 15/7/22.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSCMyTweetLikeList.h"

@interface MyTweetLikeListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *likeUserNameLabel;
@property (nonatomic, strong) UILabel *textlLikeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *authorTweetLabel;

- (void)setContentWithMyTweetLikeList:(OSCMyTweetLikeList *)myLikeTweet;

@end
