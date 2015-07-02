//
//  GrowingTextView.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrowingTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign, readonly) NSUInteger numberOfLines;
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

@end
