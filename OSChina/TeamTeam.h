//
//  TeamTeam.h
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface TeamTeam : OSCBaseObject

@property (nonatomic, assign) int teamID;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ident;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *qqNumber;

@end
