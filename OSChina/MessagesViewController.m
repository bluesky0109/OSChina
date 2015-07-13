//
//  MessagesViewController.m
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "MessagesViewController.h"
#import "Config.h"
#import "OSCMessage.h"
#import "MessageCell.h"
#import "MessageBubbleCell.h"
#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const kMessageCellID = @"MessageCell";

@implementation MessagesViewController

- (instancetype)init
{
    self = [super init];
    if (!self) {return nil;}
    
    self.generateURL = ^NSString * (NSUInteger page) {
        return [NSString stringWithFormat:@"%@%@?uid=%llu&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_MESSAGES_LIST, [Config getOwnID], (unsigned long)page, OSCAPI_SUFFIX];
    };
    
    self.objClass = [OSCMessage class];
    
    return self;
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    return [[xml.rootElement firstChildWithTag:@"messages"] childrenWithTag:@"message"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MessageBubbleCell class] forCellReuseIdentifier:kMessageCellID];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {

        OSCMessage *message = self.objects[indexPath.row];
#if 0
        MessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMessageCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor themeColor];
        [cell.portrait loadPortrait:message.portraitURL];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", message.senderID == [Config getOwnID] ? @"发给" : @"来自", message.friendName];
        cell.contentLabel.text = message.content;
        cell.timeLabel.text = [Utils intervalSinceNow:message.pubDate];
        cell.commentCountLabel.text = [NSString stringWithFormat:@"%d条留言", message.messageCount];
#else
        MessageBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageCellID forIndexPath:indexPath];
        
        [cell setContent:message.content andPortrait:message.portraitURL];
#endif
        return cell;
    } else {
        return self.lastCell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        OSCMessage *message = self.objects[indexPath.row];
#if 0
        self.label.text = message.senderName;
        CGSize nameSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 70, MAXFLOAT)];
        
        self.label.text = message.content;
        CGSize contentSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)];
        
        return nameSize.height + contentSize.height + 42;
#else
        self.label.text = message.content;
        self.label.font = [UIFont systemFontOfSize:15];
        CGSize contentSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 85, MAXFLOAT)];
        
        return contentSize.height + 36;
#endif
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.objects.count) {
        
    } else {
        [self fetchMore];
    }
}

@end
