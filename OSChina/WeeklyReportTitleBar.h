//
//  WeeklyReportTitleBar.h
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyReportTitleBar : UIView

- (instancetype)initWithFrame:(CGRect)frame andWeek:(NSInteger)week;
- (void)updateWeek:(NSInteger)week;

@end
