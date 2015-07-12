//
//  PostsCell.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *bodyLabel;
@property (nonatomic, strong) UILabel     *authorLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UILabel     *commentAndView;

@end
