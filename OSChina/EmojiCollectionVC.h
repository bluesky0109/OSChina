//
//  EmojiCollectionVC.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiCollectionVC : UICollectionViewController

@property (nonatomic, assign) NSInteger pageIndex;

- (instancetype)initWithPageIndex:(NSInteger)pageIndex;

@end
