//
//  OSCReference.h
//  OSChina
//
//  Created by sky on 15/7/14.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCReference : OSCBaseObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *body;

@end
