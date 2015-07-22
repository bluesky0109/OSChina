//
//  OSCMyTweetLikeList.h
//  OSChina
//
//  Created by sky on 15/7/22.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCMyTweetLikeList : OSCBaseObject

@property (nonatomic, readwrite, copy  ) NSString                  *name;
@property (nonatomic, readwrite, assign) int64_t                   userID;
@property (nonatomic, readwrite, strong) NSURL                     *portraitURL;

@property (nonatomic, assign           ) int64_t                   tweetId;
@property (nonatomic, copy             ) NSString                  *body;
@property (nonatomic, copy             ) NSString                  *author;

@property (nonatomic, copy             ) NSString                  *dataTime;

@property (nonatomic, copy             ) NSMutableAttributedString *authorAndBody;

@end
