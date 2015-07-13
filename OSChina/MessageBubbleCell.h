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

@interface MessageBubbleCell : UITableViewCell


- (void)setContent:(NSString *)content andPortrait:(NSURL *)portraitURL;

@end
