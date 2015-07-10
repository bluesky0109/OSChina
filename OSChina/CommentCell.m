//
//  CommentCell.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "CommentCell.h"
#import "Utils.h"
#import "OSCComment.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor themeColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubviews];
        [self setLayout];
    }
    
    return self;
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
    self.authorLabel.textColor = [UIColor colorWithHex:0x0083FF];
    self.authorLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:self.authorLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = [UIColor colorWithHex:0xA0A3A7];
    [self.contentView addSubview:self.timeLabel];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
}

- (void)setLayout
{
    for (UIView *view in [self.contentView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_portrait, _authorLabel, _timeLabel, _contentLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_portrait(36)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_portrait(36)]-5-[_authorLabel]-8-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_authorLabel]-2-[_timeLabel]-5-[_contentLabel]"
                                                                             options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                             metrics:nil
                                                                               views:views]];

}


- (void)setContentWithComment:(OSCComment *)comment {
    [self.portrait loadPortrait:comment.portraitURL];
    [self.contentLabel setAttributedText:[Utils emojiStringFromRawString:comment.content]];
    [self.authorLabel setText:comment.author];
    [self.timeLabel setText:[Utils intervalSinceNow:comment.pubDate]];
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

- (void)deleteComment:(id)sender {
    _deleteComment(self);
}

@end
