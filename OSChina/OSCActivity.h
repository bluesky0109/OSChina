//
//  OSCActivity.h
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCActivity : OSCBaseObject

@property (nonatomic, readonly, assign) int64_t  activityID;
@property (nonatomic, readonly, strong) NSURL    *coverURL;
@property (nonatomic, readonly, strong) NSURL    *url;
@property (nonatomic, readonly, copy  ) NSString *title;
@property (nonatomic, readonly, copy  ) NSString *startTime;
@property (nonatomic, readonly, copy  ) NSString *endTime;
@property (nonatomic, readonly, copy  ) NSString *createTime;
@property (nonatomic, readonly, copy  ) NSString *location;
@property (nonatomic, readonly, copy  ) NSString *city;
@property (nonatomic, readonly, assign) int      status;
@property (nonatomic, readonly, assign) int      attendence;

@end
