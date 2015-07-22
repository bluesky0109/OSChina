//
//  OSCUser.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCUser : OSCBaseObject

@property (nonatomic, assign          ) int64_t  userID;
@property (nonatomic, readonly, copy  ) NSString *location;
@property (nonatomic, copy            ) NSString *name;
@property (nonatomic, readonly, assign) int      followersCount;
@property (nonatomic, readonly, assign) int      fansCount;
@property (nonatomic, readonly, assign) int      score;
@property (nonatomic, readonly, assign) int      favoriteCount;
@property (nonatomic, assign          ) int      relationship;
@property (nonatomic, strong          ) NSURL    *portraitURL;
@property (nonatomic, readonly, copy  ) NSString *developPlatform;
@property (nonatomic, readonly, copy  ) NSString *expertise;
@property (nonatomic, readonly, copy  ) NSString *joinTime;
@property (nonatomic, readonly, copy  ) NSString *latestOnlineTime;

@end
