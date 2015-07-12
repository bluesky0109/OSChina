//
//  OSCMyInfo.h
//  OSChina
//
//  Created by sky on 15/7/12.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCMyInfo : OSCBaseObject

@property (nonatomic, readonly, copy  ) NSString *name;
@property (nonatomic, readonly, strong) NSURL    *portraitURL;
@property (nonatomic, readonly, copy  ) NSString *joinTime;
@property (nonatomic, readonly, assign) int      favoriteCount;
@property (nonatomic, readonly, assign) int      fansCount;
@property (nonatomic, readonly, assign) int      followersCount;
@property (nonatomic, readonly, assign) int      score;
@property (nonatomic, readonly, assign) int      gender;
@property (nonatomic, readonly, copy  ) NSString *developPlatform;
@property (nonatomic, readonly, copy  ) NSString *expertise;
@property (nonatomic, readonly, copy  ) NSString *hometown;

@end
