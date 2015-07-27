//
//  TeamIssueList.h
//  OSChina
//
//  Created by sky on 15/7/27.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface TeamIssueList : OSCBaseObject

@property (nonatomic     ) int64_t  listId;
@property (nonatomic,copy) NSString *listTitle;
@property (nonatomic,copy) NSString *listDescription;
@property (nonatomic     ) int64_t  archive;
@property (nonatomic     ) int      openedIssueCount;
@property (nonatomic     ) int      closedIssueCount;
@property (nonatomic     ) int      allIssueCount;

@end
