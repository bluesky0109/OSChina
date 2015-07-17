//
//  CommentsViewController.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "CommentsViewController.h"
#import "UserDetailsViewController.h"
#import "CommentCell.h"
#import "OSCComment.h"
#import "Config.h"
#import <MBProgressHUD.h>

static NSString *kCommentCellID = @"CommentCell";

@interface CommentsViewController ()

@property (nonatomic, assign) int64_t objectID;
@property (nonatomic, assign) CommentType commentType;

@end

@implementation CommentsViewController

- (instancetype)initWithCommentType:(CommentType)commentType andObjectID:(int64_t)objectID {
    self = [super init];
    if (self) {
        _objectID = objectID;
        _commentType = commentType;
        
        self.generateURL = ^NSString *(NSUInteger page) {
            NSString *URL;
            if (commentType <= 4) {
                URL = [NSString stringWithFormat:@"%@%@?catalog=%d&id=%lld&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_COMMENTS_LIST, commentType, objectID, (unsigned long)page, OSCAPI_SUFFIX];
            } else if (commentType == CommentTypeBlog) {
                URL = [NSString stringWithFormat:@"%@%@?id=%lld&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_BLOGCOMMENTS_LIST, objectID, (unsigned long)page, OSCAPI_SUFFIX];
            } else if (commentType == CommentTypeSoftware) {
                URL = [NSString stringWithFormat:@"%@%@?project=%lld&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_SOFTWARE_TWEET_LIST, objectID, (unsigned long)page, OSCAPI_SUFFIX];
            }
            return URL;
        };
        
        self.objClass = [OSCComment class];
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:kCommentCellID];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)],[[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteComment:)]]];
    [menuController setMenuVisible:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"comments"] childrenWithTag:@"comment"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.otherSectionCell) {
        return 1;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (indexPath.section == 0 && self.otherSectionCell) {
        UITableViewCell *cell = self.otherSectionCell(indexPath);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (row < self.objects.count) {
//        CommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCommentCellID forIndexPath:indexPath];
        CommentCell *cell = [CommentCell new];
        OSCComment *comment = self.objects[indexPath.row];
        
        [self setBlockForCommentCell:cell];
        
        [cell setContentWithComment:comment];
        cell.portrait.tag = row;
        cell.authorLabel.tag = row;
        [cell.portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetailsView:)]];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.otherSectionCell) {
        return self.heightForOtherSectionCell(indexPath);
    } else if (indexPath.row < self.objects.count) {
        OSCComment *comment = self.objects[indexPath.row];
        
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithAttributedString:[Utils emojiStringFromRawString:comment.content]];
        if (comment.replies.count > 0) {
            [contentString appendAttributedString:[OSCComment attributedTextFromReplies:comment.replies]];
        }
        [self.label setAttributedText:contentString];
        
        self.label.font = [UIFont boldSystemFontOfSize:14];
        __block CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 57, MAXFLOAT)].height;
        CGFloat width = self.tableView.frame.size.width - 57;

        NSArray *references = comment.references;
        if (references.count > 0) {
            height += 3;
        }

        self.label.font = [UIFont systemFontOfSize:13];
        [references enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(OSCReference *reference, NSUInteger idx, BOOL *stop) {
            self.label.text = [NSString stringWithFormat:@"%@\n%@", reference.title, reference.body];
            height += [self.label sizeThatFits:CGSizeMake(width - (references.count-idx)*10, MAXFLOAT)].height + 13;
        }];
        return height + 60;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.otherSectionCell) {
        //不响应点击
    } else if (indexPath.row < self.objects.count) {
        OSCComment *comment = self.objects[indexPath.row];
        if (self.didCommentSelected) {
            self.didCommentSelected(comment);
        }
    } else {
        [self fetchMore];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return action == @selector(copyText:);
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    //required
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.didScroll) {
        self.didScroll();
    }
}


- (void)setBlockForCommentCell:(CommentCell *)cell {
    cell.canPerformAction = ^BOOL (UITableViewCell *cell, SEL action) {
        if (action == @selector(copyText:)) {
            return YES;
        } else if (action == @selector(deleteComment:)) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            OSCComment *comment = self.objects[indexPath.row];
            int64_t ownID = [Config getOwnID];
            
            return (comment.authorID == ownID || _objectAuthorID == ownID);
        }
        
        return NO;
    };
    
    cell.deleteComment = ^ (UITableViewCell *cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        OSCComment *comment = self.objects[indexPath.row];
        
        MBProgressHUD *HUD = [Utils createHUDInWindowOfView:self.view];
        HUD.labelText = @"正在删除评论";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
        [manager POST:[NSString stringWithFormat:@"%@%@?", OSCAPI_PREFIX, OSCAPI_COMMENT_DELETE]
           parameters:@{
                        @"catalog": @(_commentType),
                        @"id": @(_objectID),
                        @"replyid": @(comment.commentID),
                        @"authorid": @(comment.authorID)
                        }
              success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
                  ONOXMLElement *resultXML = [responseObject.rootElement firstChildWithTag:@"result"];
                  int errorCode = [[[resultXML firstChildWithTag: @"errorCode"] numberValue] intValue];
                  NSString *errorMessage = [[resultXML firstChildWithTag:@"errorMessage"] stringValue];
                  
                  HUD.mode = MBProgressHUDModeCustomView;
                  
                  switch (errorCode) {
                      case 1: {
                          HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                          HUD.labelText = @"评论删除成功";
                          
                          [self.objects removeObjectAtIndex:indexPath.row];
                          [self.tableView beginUpdates];
                          [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                          [self.tableView endUpdates];
                          
                          break;
                      }
                      case 0:
                      case -2:
                      case -1: {
                          HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                          HUD.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
                          break;
                      }
                      default: break;
                  }
                  
                  [HUD hide:YES afterDelay:1];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  HUD.mode = MBProgressHUDModeCustomView;
                  HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                  HUD.labelText = @"网络异常，操作失败";
                  
                  [HUD hide:YES afterDelay:1];
              }];
    };
}


#pragma mark - 跳转到用户详情页

- (void)pushDetailsView:(UITapGestureRecognizer *)tapGesture
{
    OSCComment *comment = self.objects[tapGesture.view.tag];
    UserDetailsViewController *userDetailsVC = [[UserDetailsViewController alloc] initWithUserID:comment.authorID];
    [self.navigationController pushViewController:userDetailsVC animated:YES];
}

@end
