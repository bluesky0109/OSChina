//
//  DetailsViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DetailsType)
{
    DetailsTypeNews,
    DetailsTypeBlog,
    DetailsTypeSoftware
};

@interface DetailsViewController : UIViewController

- (instancetype)initWithDetailsType:(DetailsType)type andID:(int64_t)detailsID;

@end
