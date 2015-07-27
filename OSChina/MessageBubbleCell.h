//
//  MessageBubbleCell.h
//  OSChina
//
//  Created by sky on 15/7/13.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kMessageBubbleOthers = @"MessageBubbleOthers";
static NSString *const kMessageBubbleMe     = @"MessageBubbleMe";

@class OSCComment;

@interface MessageBubbleCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;

@property (nonatomic, copy) BOOL (^canPerformAction)(UITableViewCell *cell, SEL action);
@property (nonatomic, copy) void (^deleteObject)(UITableViewCell *cell);

- (void)setContent:(NSString *)content andPortrait:(NSURL *)portraitURL;
- (void)deleteObject:(id)sender;
- (void)copyText:(id)sender;

@end
