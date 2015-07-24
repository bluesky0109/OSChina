//
//  TeamActivityCell.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeamActivity;

@interface TeamActivityCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)setContentWithActivity:(TeamActivity *)activity;

@end
