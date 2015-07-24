//
//  TeamIssueCell.m
//  OSChina
//
//  Created by sky on 15/7/24.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TeamIssueCell.h"
#import "Utils.h"
#import "TeamIssue.h"

@implementation TeamIssueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor themeColor];
        
        [self initSubviews];
        [self setLayout];
        
        UIView *selectedBackground = [UIView new];
        selectedBackground.backgroundColor = [UIColor colorWithHex:0xF5FFFA];
        [self setSelectedBackgroundView:selectedBackground];
    }
    return self;
}

- (void)initSubviews {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //_titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor colorWithHex:0xA0A3A7];
    [self.contentView addSubview:_timeLabel];
    
    _commentLabel = [UILabel new];
    _commentLabel.font = [UIFont systemFontOfSize:12];
    _commentLabel.textColor = [UIColor colorWithHex:0xA0A3A7];
    [self.contentView addSubview:_commentLabel];
    
    _assignmentLabel = [UILabel new];
    _assignmentLabel.font = [UIFont systemFontOfSize:12];
    _assignmentLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_assignmentLabel];
    
    _projectNameLabel = [UILabel new];
    _projectNameLabel.numberOfLines = 0;
    _projectNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _projectNameLabel.font = [UIFont systemFontOfSize:14];
    _projectNameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_projectNameLabel];
}

- (void)setLayout {
    for (UIView *view in self.contentView.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _projectNameLabel, _assignmentLabel, _timeLabel, _commentLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleLabel]-8-[_projectNameLabel]-8-[_assignmentLabel]-8-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_titleLabel]-8-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_assignmentLabel]->=0-[_timeLabel]-8-|"
                                                                             options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
}


- (void)setContentWithissue:(TeamIssue *)issue {
    _titleLabel.text = issue.title;
    
    _projectNameLabel.text = issue.project.projectName;
    _timeLabel.attributedText = [Utils attributedTimeString:issue.createTime];
    
    if (issue.user.name) {
        _assignmentLabel.text = [NSString stringWithFormat:@"%@ 指派给 %@", issue.author.name, issue.user.name];
    } else {
        _assignmentLabel.text = [NSString stringWithFormat:@"%@ 未指派", issue.author.name];
    }
}


@end
