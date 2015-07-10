//
//  RandomMessageCell.h
//  OSChina
//
//  Created by sky on 15/7/10.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCRandomMessage;

@interface RandomMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UILabel     *authorLabel;
@property (nonatomic, strong) UILabel     *commentCount;
@property (nonatomic, strong) UILabel     *timeLabel;

- (void)setContentWithMessage:(OSCRandomMessage *)message;

@end
