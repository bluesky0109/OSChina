//
//  MessageBubbleViewController.m
//  OSChina
//
//  Created by sky on 15/7/13.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "MessageBubbleViewController.h"
#import "UserDetailsViewController.h"
#import "MessageBubbleCell.h"
#import "OSCComment.h"
#import "Config.h"
#import <MBProgressHUD.h>

@interface MessageBubbleViewController ()

@end

@implementation MessageBubbleViewController

- (instancetype)initWithUserID:(int64_t)userID andUserName:(NSString *)userName {
    self = [super init];
    if (self) {
        self.navigationItem.title = userName;
        
        self.generateURL = ^NSString *(NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?catalog=4&id=%llu&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_COMMENTS_LIST, userID, (unsigned long)page, OSCAPI_SUFFIX];
        };
        
        self.objClass = [OSCComment class];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:YES animated:YES];
    [menuController setMenuItems:@[
                                   [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)],
                                   [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)]
                                   ]];
    
    [self.tableView registerClass:[MessageBubbleCell class] forCellReuseIdentifier:kMessageBubbleMe];
    [self.tableView registerClass:[MessageBubbleCell class] forCellReuseIdentifier:kMessageBubbleOthers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"comments"] childrenWithTag:@"comment"];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        OSCComment *message = self.objects[indexPath.row];
        
        MessageBubbleCell *cell = nil;
        
        if (message.authorID == [Config getOwnID]) {
            cell = [tableView dequeueReusableCellWithIdentifier:kMessageBubbleMe forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:kMessageBubbleOthers forIndexPath:indexPath];
        }
        cell.portrait.tag = message.authorID;
        [cell.portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserDetails:)]];
        [cell setContent:message.content andPortrait:message.portraitURL];
        
        [self setBlockForMessageCell:cell];
        
        return cell;
        
    } else {
        return self.lastCell;
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        OSCComment *message = self.objects[indexPath.row];
        
        self.label.text = message.content;
        self.label.font = [UIFont systemFontOfSize:15];
        CGSize contentSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 85, MAXFLOAT)];
        
        return contentSize.height + 36;
    } else {
        return 60;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView && self.didScroll) {
        self.didScroll();
    }
}

#pragma mark - 头像点击处理
- (void)pushUserDetails:(UIGestureRecognizer *)recognizer {
    [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithUserID:recognizer.view.tag] animated:YES];
}

#pragma mark - 删除留言

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return action == @selector(deleteMessage:);
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    // required
}

#pragma mark - UIScrollViewDelegate

- (void)setBlockForMessageCell:(MessageBubbleCell *)cell {
    cell.canPerformAction = ^ BOOL (UITableViewCell *cell, SEL action) {
        if (action == @selector(copyText:)) {
            return YES;
        } else if (action == @selector(deleteMessage:)) {
            return YES;
        }

        return NO;
    };

    cell.deleteMessage = ^ (UITableViewCell *cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        OSCComment *comment = self.objects[indexPath.row];

        MBProgressHUD *HUD = [Utils createHUD];
        HUD.labelText = @"正在删除留言";

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
        [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_COMMENT_DELETE]
           parameters:@{@"catalog": @(4),
                        @"id": @([Config getOwnID]),
                        @"replyid": @(comment.commentID),
                        @"authorid": @(comment.authorID)
                        }
              success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
                  ONOXMLElement *resultXML = [responseObject.rootElement firstChildWithTag:@"result"];
                  int errorCode = [[[resultXML firstChildWithTag: @"errorCode"] numberValue] intValue];
                  NSString *errorMessage = [[resultXML firstChildWithTag:@"errorMessage"] stringValue];

                  HUD.mode = MBProgressHUDModeCustomView;

                  if (errorCode == 1) {
                      HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                      HUD.labelText = @"留言删除成功";

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
