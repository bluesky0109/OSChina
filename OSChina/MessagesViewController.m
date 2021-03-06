//
//  MessagesViewController.m
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "MessagesViewController.h"
#import "BubbleChatViewController.h"
#import "UserDetailsViewController.h"
#import "Config.h"
#import "OSCMessage.h"
#import "MessageCell.h"
#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>

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
        
        [self setBlockForMessageCell:cell];
        
        cell.backgroundColor = [UIColor themeColor];
        [cell.portrait loadPortrait:message.portraitURL];
        cell.portrait.tag = message.friendID;
        [cell.portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserDetails:)]];
        
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


#pragma mark - 头像点击处理
- (void)pushUserDetails:(UIGestureRecognizer *)recognizer {
    [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithUserID:recognizer.view.tag] animated:YES];
}

#pragma mark - 删除回复

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return action == @selector(deleteObject:);
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    // required
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_didScroll) {_didScroll();}
}

- (void)setBlockForMessageCell:(MessageCell *)cell {
    cell.canPerformAction = ^ BOOL (UITableViewCell *cell, SEL action) {
        if (action == @selector(deleteObject:)) {
            return YES;
        }
        return NO;
    };

    cell.deleteObject = ^ (UITableViewCell *cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        OSCMessage *message = self.objects[indexPath.row];

        MBProgressHUD *HUD = [Utils createHUD];
        HUD.labelText = @"正在删除回复";

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
        [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_MESSAGE_DELETE]
           parameters:@{
                        @"friendid": @(message.friendID),
                        @"uid": @([Config getOwnID])
                        }
              success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
                  ONOXMLElement *resultXML = [responseObject.rootElement firstChildWithTag:@"result"];
                  int errorCode = [[[resultXML firstChildWithTag: @"errorCode"] numberValue] intValue];
                  NSString *errorMessage = [[resultXML firstChildWithTag:@"errorMessage"] stringValue];

                  HUD.mode = MBProgressHUDModeCustomView;

                  if (errorCode == 1) {
                      HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                      HUD.labelText = @"回复删除成功";

                      [self.objects removeObjectAtIndex:indexPath.row];
                      self.allCount--;
                      if (self.objects.count > 0) {
                          [self.tableView beginUpdates];
                          [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                          [self.tableView endUpdates];
                      }
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self.tableView reloadData];
                      });
                  } else {
                      HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                      HUD.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
                  }
                  
                  [HUD hide:YES afterDelay:1];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  HUD.mode = MBProgressHUDModeCustomView;
                  HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                  HUD.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
                  
                  [HUD hide:YES afterDelay:1];
              }];
    };
}

@end
