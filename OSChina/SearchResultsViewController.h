//
//  SearchResultsViewController.h
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"

@interface SearchResultsViewController : OSCObjsViewController

@property (nonatomic, copy, readonly) NSString *keyword;

- (instancetype)initWithType:(NSString *)type;

@end
