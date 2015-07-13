//
//  OSCUser.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCUser : OSCBaseObject

@property (nonatomic, assign, readonly  ) int64_t  userID;
@property (nonatomic, copy, readonly    ) NSString *location;
@property (nonatomic, copy, readonly    ) NSString *name;
@property (nonatomic, assign, readonly  ) int      followersCount;
@property (nonatomic, assign, readonly  ) int      fansCount;
@property (nonatomic, assign ,readonly  ) int      score;
@property (nonatomic, assign, readonly  ) int      relationship;
@property (nonatomic, strong, readonly  ) NSURL    *portraitURL;
@property (nonatomic, copy, readonly    ) NSString *expertise;
@property (nonatomic, copy, readonly    ) NSString *latestOnlineTime;

@end
