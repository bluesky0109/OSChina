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

@interface CommentCell()

@property (nonatomic, strong) UIView *currentContainer;

@end


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
    self.authorLabel.textColor = [UIColor nameColor];
    self.authorLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:self.authorLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
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
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_portrait(36)]-8-[_authorLabel]-8-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[_authorLabel]-4-[_timeLabel]->=5-[_contentLabel]-8-|"
                                                                             options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                             metrics:nil
                                                                               views:views]];

}


- (void)setContentWithComment:(OSCComment *)comment {
    [self.portrait loadPortrait:comment.portraitURL];
    [self.authorLabel setText:comment.author];
    [self.timeLabel setText:[Utils intervalSinceNow:comment.pubDate]];
    
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithAttributedString:[Utils emojiStringFromRawString:comment.content]];
    if (comment.replies.count > 0) {
        [contentString appendAttributedString:[OSCComment attributedTextFromReplies:comment.replies]];
    }
    
    [self.contentLabel setAttributedText:contentString];
    
    [self dealWithReferences:comment.references];
}

- (void)dealWithReferences:(NSArray *)references {
    if (references.count == 0) {
        return;
    }
    
    _currentContainer = [UIView new];
    [self.contentView addSubview:_currentContainer];
    _currentContainer.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_timeLabel,_contentLabel,_currentContainer);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeLabel]-8-[_currentContainer]-8-[_contentLabel]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    
    for (OSCReference *reference in [references reverseObjectEnumerator]) {
        [_currentContainer setBorderWidth:1.0 andColor:[UIColor lightGrayColor]];
        _currentContainer.backgroundColor = [UIColor colorWithHex:0xFFFAF0];
        
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:13];
        
        NSMutableAttributedString *referenceText = [[NSMutableAttributedString alloc] initWithString:reference.title
                                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor nameColor]}];
        [referenceText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", reference.body]]];
        label.attributedText = referenceText;
        label.backgroundColor = [UIColor colorWithHex:0xFFFAF0];
        [_currentContainer addSubview:label];
        
        UIView *container = [UIView new];
        [_currentContainer addSubview:container];
        
        for (UIView *view in _currentContainer.subviews) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        NSDictionary *views = NSDictionaryOfVariableBindings(label, container);
        
        [_currentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[container]-<=5-[label]-4-|"
                                                                                  options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                                  metrics:nil views:views]];
        
        [_currentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-4-[container]-4-|" options:0 metrics:nil views:views]];
        
        _currentContainer = container;
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

- (void)deleteComment:(id)sender {
    _deleteComment(self);
}

@end
