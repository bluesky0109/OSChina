//
//  TimeLineNodeCell.h
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineNodeCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView  *upperLine;
@property (nonatomic, strong) UIView  *underLine;

- (void)setContentWithString:(NSAttributedString *)HTML;

@end
