//
//  TeamIssueCell.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeamIssue;

@interface TeamIssueCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *projectNameLabel;
@property (nonatomic, strong) UILabel *assignmentLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)setContentWithIssue:(TeamIssue *)issue;

@end
