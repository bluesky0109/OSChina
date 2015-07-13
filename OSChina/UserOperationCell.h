//
//  UserOperationCell.h
//  OSChina
//
//  Created by sky on 15/7/13.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserOperationCell : UITableViewCell

@property (nonatomic, strong) UILabel  *loginTimeLabel;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *blogsButton;
@property (nonatomic, strong) UIButton *informationButton;

- (void)setFollowButtonByRelationship:(int)relationship;

@end
