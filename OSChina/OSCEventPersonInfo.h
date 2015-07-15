//
//  OSCEventPersonInfo.h
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCEventPersonInfo : OSCBaseObject

@property (nonatomic, readonly, copy  ) NSString *userName;
@property (nonatomic, readonly, assign) int64_t  userID;
@property (nonatomic, readonly, strong) NSURL    *portraitURL;
@property (nonatomic, readonly, copy  ) NSString *company;
@property (nonatomic, readonly, copy  ) NSString *job;

@end
