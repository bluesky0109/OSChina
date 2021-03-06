//
//  EventCell.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kEventWithImageCellID        = @"EventCellWithImage";
static NSString * const kEventWithReferenceCellID    = @"EventCellWithReference";
static NSString * const kEventWithoutExtraInfoCellID = @"EventCellWithoutExtraInfo";

@class OSCEvent;

@interface EventCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *authorLabel;
@property (nonatomic, strong) UILabel     *actionLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UIImageView *thumbnail;

@property (nonatomic, strong) UITextView  *referenceText;
@property (nonatomic, strong) UILabel     *appclientLabel;
@property (nonatomic, strong) UILabel     *commentCount;
@property (nonatomic, strong) UIView      *extraInfoView;

@property (nonatomic, copy) BOOL (^canPerformAction)(UITableViewCell *cell, SEL action);

- (void)setContentWithEvent:(OSCEvent *)event;

- (void)copyText:(id)sender;

@end
