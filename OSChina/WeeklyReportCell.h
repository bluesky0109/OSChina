//
//  WeeklyReportCell.h
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeamWeeklyReport;

@interface WeeklyReportCell : UITableViewCell

@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UILabel     *commentLabel;

- (void)setContentWithWeeklyReport:(TeamWeeklyReport *)weeklyReport;

@end
