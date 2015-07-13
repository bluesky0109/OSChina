//
//  MessageBubbleCell.h
//  OSChina
//
//  Created by sky on 15/7/13.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageBubbleCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *messageLabel;

- (void)setContent:(NSString *)content andPortrait:(NSURL *)portraitURL;

@end
