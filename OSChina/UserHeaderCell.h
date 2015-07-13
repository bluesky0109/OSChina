//
//  UserHeaderCell.h
//  OSChina
//
//  Created by sky on 15/7/13.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCUser;

@interface UserHeaderCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *creditsButton;
@property (nonatomic, strong) UIButton *followsButton;
@property (nonatomic, strong) UIButton *fansButton;

- (void)setContentWithUser:(OSCUser *)user;

@end
