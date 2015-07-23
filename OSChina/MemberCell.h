//
//  MemberCell.h
//  OSChina
//
//  Created by sky on 15/7/21.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeamMember;

@interface MemberCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel     *nameLabel;

- (void)setContentWithMember:(TeamMember *)member;

@end
