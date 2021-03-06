//
//  EmojiPanelView.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "EmojiPanelVC.h"
#import <objc/runtime.h>

@interface EmojiPanelVC()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *emojiCollectionView;

@end

@implementation EmojiPanelVC

-(instancetype)initWithPageIndex:(int)pageIndex {
    if (self = [super init]) {
        _pageIndex = pageIndex;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    flowLayout.minimumInteritemSpacing = (screenWidth - 40 - 30 * 7) / 7;
    flowLayout.minimumLineSpacing = 25;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 0, 5, 0);
    
    _emojiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_emojiCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EmojiCell"];
    _emojiCollectionView.backgroundColor = [UIColor whiteColor];
    _emojiCollectionView.scrollEnabled = NO;
    _emojiCollectionView.dataSource = self;
    _emojiCollectionView.delegate = self;
    _emojiCollectionView.bounces = NO;
    [self.view addSubview:_emojiCollectionView];
    
    _emojiCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_emojiCollectionView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_emojiCollectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_emojiCollectionView]-20-|" options:0 metrics:nil views:views]];
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
    
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;

    if (section == 2 && row == 6) {
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete"]]];
    } else {
        NSInteger emojiNum = _pageIndex * 20 + indexPath.section * 7 + row + 1;
        NSString *emojiName = [NSString stringWithFormat:@"%03ld", (long)emojiNum];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:emojiName]]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    if (section == 2 && row == 6) {
        _deleteEmoji();
    } else {
        NSInteger emojiNum = _pageIndex * 20 + indexPath.section * 7 + row + 1;
        NSString *emojiName = [NSString stringWithFormat:@"%03ld", (long)emojiNum];
        
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        textAttachment.image = [UIImage imageNamed:emojiName];
        objc_setAssociatedObject(textAttachment, @"number", @(emojiNum), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        _didSelectEmoji(textAttachment);
    }
}

@end
