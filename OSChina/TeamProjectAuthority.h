//
//  TeamProjectAuthority.h
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface TeamProjectAuthority : OSCBaseObject

@property (nonatomic, assign) BOOL authDelete;
@property (nonatomic, assign) BOOL authUpdateState;
@property (nonatomic, assign) BOOL authUpdateAssignee;
@property (nonatomic, assign) BOOL authUpdateDeadline;
@property (nonatomic, assign) BOOL authUpdatePriority;
@property (nonatomic, assign) BOOL authUpdateLabels;

@end
