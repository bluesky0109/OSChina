//
//  MessageCell.h
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UILabel     *commentCountLabel;

@end
