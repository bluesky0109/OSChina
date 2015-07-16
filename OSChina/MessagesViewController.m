//
//  MessagesViewController.m
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "MessagesViewController.h"
#import "BubbleChatViewController.h"
#import "Config.h"
#import "OSCMessage.h"
#import "MessageCell.h"
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
    
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:kMessageCellID];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {

        OSCMessage *message = self.objects[indexPath.row];
        
        MessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMessageCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor themeColor];
        [cell.portrait loadPortrait:message.portraitURL];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", message.senderID == [Config getOwnID] ? @"发给" : @"来自", message.friendName];
        cell.contentLabel.text = message.content;
        cell.timeLabel.text = [Utils intervalSinceNow:message.pubDate];
        cell.commentCountLabel.text = [NSString stringWithFormat:@"%d条留言", message.messageCount];

        return cell;
    } else {
        return self.lastCell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        OSCMessage *message = self.objects[indexPath.row];

        self.label.text = message.senderName;
        self.label.font = [UIFont boldSystemFontOfSize:14];
        CGSize nameSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 70, MAXFLOAT)];
        
        self.label.text = message.content;
        self.label.font = [UIFont boldSystemFontOfSize:15];
        CGSize contentSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)];
        
        return nameSize.height + contentSize.height + 38;

    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.objects.count) {
        OSCMessage *message = self.objects[indexPath.row];
        BubbleChatViewController *bubbleChatVC = [[BubbleChatViewController alloc] initWithUserID:message.friendID andUserName:message.friendName];
        
        [self.navigationController pushViewController:bubbleChatVC animated:YES];
        
    } else {
        [self fetchMore];
    }
}

@end
