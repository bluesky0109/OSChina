//
//  OSCSoftwareCatalog.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCSoftwareCatalog : OSCBaseObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) int tag;

@end
