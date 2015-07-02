//
//  EmojiPanelView.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "EmojiPanelView.h"
#import "UIColor+Util.h"

@implementation EmojiPanelView

-(instancetype)initWithPanelHeight:(CGFloat)panelHeight {
    if (self = [super init]) {
        [self setLayoutWithPanelHeight:panelHeight];
        self.backgroundColor = [UIColor colorWithHex:0xF5FAFA];
    }
    return self;
}

- (void)setLayoutWithPanelHeight:(CGFloat)panelHeight
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    
    _emojiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_emojiCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EmojiCell"];
    _emojiCollectionView.backgroundColor = [UIColor clearColor];
    _emojiCollectionView.dataSource = self;
    _emojiCollectionView.delegate = self;
    _emojiCollectionView.bounces = NO;
    
    _pageControl = [UIPageControl new];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    
    [self addSubview:_pageControl];
    [self addSubview:_emojiCollectionView];
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    _emojiCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_emojiCollectionView, _pageControl);
    NSDictionary *metrics = @{@"eH": @(panelHeight-20), @"pH": @20};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_emojiCollectionView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_emojiCollectionView(eH)][_pageControl(pH)]|"
                                                                 options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                 metrics:metrics
                                                                   views:views]];
}

#pragma makr - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCell" forIndexPath:indexPath];
    
    NSInteger emojiNum = _pageControl.currentPage * 20 + indexPath.section * 7 + indexPath.row;
    NSString *emojiName = [NSString stringWithFormat:@"03%ld",emojiNum];
    [cell addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:emojiName]]];
    
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = _emojiCollectionView.frame.size.width;
    _pageControl.currentPage = _emojiCollectionView.contentOffset.x / pageWidth;
}
@end
