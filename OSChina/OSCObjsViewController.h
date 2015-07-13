//
//  OSCObjsViewController.h
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>

#import "Utils.h"
#import "OSCAPI.h"
#import "LastCell.h"

@class ONOXMLDocument;

@interface OSCObjsViewController : UITableViewController

@property (nonatomic, copy) void (^parseExtraInfo)(ONOXMLDocument *);
@property (nonatomic, copy) NSString * (^generateURL)(NSUInteger page);
@property (nonatomic, copy) void (^tableWillReload)(NSUInteger responseObjectsCount);

@property Class objClass;

@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) int allCount;
@property (nonatomic, strong) LastCell *lastCell;
@property (nonatomic, strong) UILabel *label;

- (void)fetchMore;
- (NSArray *)parseXML:(ONOXMLDocument *)xml;
- (void)refresh;

@end
