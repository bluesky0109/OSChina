//
//  OSCBlog.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCBlog : OSCBaseObject

@property (nonatomic, assign) int64_t  blogID;
@property (nonatomic, copy  ) NSString *author;
@property (nonatomic, assign) int64_t  authorID;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *body;
@property (nonatomic, copy  ) NSString *pubDate;
@property (nonatomic, assign) int      commentCount;
@property (nonatomic, assign) int      documentType;

@property (nonatomic, strong)NSMutableAttributedString *attributedTitle;
@property (nonatomic, strong)NSMutableAttributedString *attributedCommentCount;

@end
