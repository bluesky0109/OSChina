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

@end
