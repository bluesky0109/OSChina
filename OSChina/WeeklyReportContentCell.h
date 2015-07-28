//
//  WeeklyReportContentCell.h
//  OSChina
//
//  Created by sky on 15/7/28.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeamWeeklyReportDetail;

@interface WeeklyReportContentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *authorLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UILabel     *contentLabel;

- (void)setContentWithReportDetail:(TeamWeeklyReportDetail *)detail;

@end
