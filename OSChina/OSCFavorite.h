//
//  OSCFavorite.h
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCBaseObject.h"

typedef NS_ENUM(int, FavoritesType)
{
    FavoritesTypeSoftware,
    FavoritesTypeTopic,
    FavoritesTypeBlog,
    FavoritesTypeNews,
    FavoritesTypeCode
};

@interface OSCFavorite : OSCBaseObject

@property (nonatomic, assign) int64_t       objectID;
@property (nonatomic, assign) FavoritesType type;
@property (nonatomic, copy  ) NSString      *title;
@property (nonatomic, strong) NSURL         *url;

@end
