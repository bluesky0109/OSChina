//
//  OSCSoftware.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCSoftware : OSCBaseObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *softwareDescription;
@property (nonatomic, copy) NSURL *url;

@end
