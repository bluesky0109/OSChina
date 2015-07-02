//
//  SoftwareListVC.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(int, SoftwaresType)
{
    SoftwaresTypeRecommended,
    SoftwaresTypeNewest,
    SoftwaresTypeHottest,
    SoftwaresTypeCN
};

@interface SoftwareListVC : OSCObjsViewController

- (instancetype)initWithSoftwaresType:(SoftwaresType)softwareType;
- (instancetype)initWIthSearchTag:(int)searchTag;

@end
