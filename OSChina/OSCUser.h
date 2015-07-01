//
//  OSCUser.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCUser : OSCBaseObject

@property (nonatomic, assign, readonly) int64_t  userID;
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) unsigned long     followersCount;
@property (nonatomic, assign, readonly) unsigned long     fansCount;
@property (nonatomic, assign ,readonly) long     score;
@property (nonatomic, copy, readonly  ) NSURL    *portraitURL;

@end
