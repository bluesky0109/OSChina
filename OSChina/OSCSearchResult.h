//
//  OSCSearchResult.h
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCSearchResult : OSCBaseObject

@property (nonatomic, readonly, assign) int64_t  objectID;
@property (nonatomic, readonly, copy  ) NSString *type;
@property (nonatomic, readonly, copy  ) NSString *title;
@property (nonatomic, readonly, copy  ) NSString *author;
@property (nonatomic, readonly, copy  ) NSString *objectDescription;
@property (nonatomic, readonly, copy  ) NSString *url;
@property (nonatomic, readonly, copy  ) NSString *pubDate;

@end
