//
//  TweetCell.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-14.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "TweetCell.h"
#import "Utils.h"
#import "OSCTweet.h"
#import "OSCUser.h"

@interface TweetCell()

@end


@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor themeColor];
        
        self.thumbnailConstraints = [NSArray new];
        self.noThumbnailConstraints = [NSArray new];
        
        [self initSubviews];
        [self setLayout];
        
        UIView *selectedBackground = [UIView new];
        selectedBackground.backgroundColor = [UIColor colorWithHex:0xF5FFFA];
        [self setSelectedBackgroundView:selectedBackground];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initSubviews
{
    self.portrait = [UIImageView new];
    self.portrait.contentMode = UIViewContentModeScaleAspectFit;
    self.portrait.userInteractionEnabled = YES;
    [self.portrait setCornerRadius:5.0];
    [self.contentView addSubview:self.portrait];

    self.authorLabel = [UILabel new];
    self.authorLabel.font = [UIFont boldSystemFontOfSize:14];
    self.authorLabel.userInteractionEnabled = YES;
    self.authorLabel.textColor = [UIColor nameColor];
    [self.contentView addSubview:self.authorLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithHex:0xA0A3A7];
    [self.contentView addSubview:self.timeLabel];
    
    self.appclientLabel = [UILabel new];
    self.appclientLabel.font = [UIFont systemFontOfSize:12];
    self.appclientLabel.textColor = [UIColor colorWithHex:0xA0A3A7];
    [self.contentView addSubview:self.appclientLabel];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
    
    self.likeButton = [UIButton new];
    [self.contentView addSubview:self.likeButton];
    
    self.commentCount = [UILabel new];
    self.commentCount.font = [UIFont systemFontOfSize:12];
    self.commentCount.textColor = [UIColor colorWithHex:0xA0A3A7];
    [self.contentView addSubview:self.commentCount];
    
    self.thumbnail = [UIImageView new];
    self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbnail.clipsToBounds = YES;
    self.thumbnail.userInteractionEnabled = YES;
    [self.contentView addSubview:self.thumbnail];
    
    //点赞列表
    _likeListLabel = [UILabel new];
    _likeListLabel.numberOfLines = 0;
    _likeListLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _likeListLabel.font = [UIFont systemFontOfSize:12];
    _likeListLabel.userInteractionEnabled = YES;
    _likeListLabel.textColor = [UIColor colorWithHex:0xA0A3A7];
    [self.contentView addSubview:_likeListLabel];
}

- (void)setLayout
{
    for (UIView *view in self.contentView.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_portrait, _authorLabel, _timeLabel, _appclientLabel, _contentLabel, _likeButton, _commentCount, _likeListLabel, _thumbnail);
    

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_portrait(36)]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_portrait(36)]-8-[_authorLabel]-8-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_authorLabel]-5-[_contentLabel]-<=6-[_thumbnail(80)]-<=6-[_likeListLabel]-6-[_timeLabel]-5-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_thumbnail(80)]"
                                                                             options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_timeLabel]-10-[_appclientLabel]->=5-[_likeButton(30)]-5-[_commentCount]-8-|"
                                                                             options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_likeListLabel]-8-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_authorLabel  attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                                    toItem:_contentLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
}

- (void)setContentWithTweet:(OSCTweet *)tweet {
    [self.portrait loadPortrait:tweet.portraitURL];
    [self.authorLabel setText:tweet.author];
    [self.timeLabel setAttributedText:[Utils attributedTimeString:tweet.pubDate]];
    [self.commentCount setAttributedText:tweet.attributedCommentCount];
    [self.appclientLabel setAttributedText:[Utils getAppclient:tweet.appclient]];
    if (tweet.isLike) {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_unlike"] forState:UIControlStateNormal];
    }

    // 添加语音图片
    if (tweet.attach.length) {
        //有语音
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        textAttachment.image = [UIImage imageNamed:@"audioTweet"];
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSMutableAttributedString *attributedTweetBody = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
        [attributedTweetBody appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [attributedTweetBody appendAttributedString:[Utils emojiStringFromRawString:tweet.body]];

        [_contentLabel setAttributedText:attributedTweetBody];
    } else {
        [_contentLabel setAttributedText:[Utils emojiStringFromRawString:tweet.body]];
    }
    
    [_likeListLabel setAttributedText:tweet.likersString];
    if (tweet.likeList.count > 0) {
        _likeListLabel.hidden = NO;
    } else {
        _likeListLabel.hidden = YES;
    }
}

#pragma mark - 处理长按操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return _canPerformAction(self,action);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)copyText:(id)sender {
    UIPasteboard *pastedBoard = [UIPasteboard generalPasteboard];
    [pastedBoard setString:_contentLabel.text];
}

- (void)deleteObject:(id)sender {
    _deleteObject(self);
}

@end
