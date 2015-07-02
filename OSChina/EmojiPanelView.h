//
//  EmojiPanelView.h
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiPanelView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *emojiCollectionView;
@property (nonatomic, strong) UIPageControl    *pageControl;


- (instancetype)initWithPanelHeight:(CGFloat)panelHeight;

@end
