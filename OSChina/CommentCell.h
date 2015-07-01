//
//  CommentCell.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *authorLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UIView      *repliesView;

@end
