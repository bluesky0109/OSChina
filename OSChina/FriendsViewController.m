//
//  FriendsViewController.m
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "FriendsViewController.h"
#import "UserDetailsViewController.h"
#import "OSCUser.h"
#import "PersonCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const kPersonCellID = @"PersonCell";

@interface FriendsViewController ()

@property (nonatomic, assign) int64_t uid;

@end

@implementation FriendsViewController

- (instancetype)initWithUserID:(int64_t)userID andFriendsRelation:(int)relation {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.generateURL = ^NSString *(NSUInteger page) {
        return [NSString stringWithFormat:@"%@%@?uid=%lld&relation=%d&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_FRIENDS_LIST, userID, relation, (unsigned long)page, OSCAPI_SUFFIX];
    };
    self.uid = userID;
    self.objClass = [OSCUser class];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PersonCell class] forCellReuseIdentifier:kPersonCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"friends"] childrenWithTag:@"friend"];
}

#pragma mark - UITableDataSource
// 图片的高度计算方法参考 http://blog.cocoabit.com/blog/2013/10/31/guan-yu-uitableview-zhong-cell-zi-gua-ying-gao-du-de-wen-ti/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row < self.objects.count) {
        OSCUser *friend = self.objects[row];
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonCellID forIndexPath:indexPath];
        
        [cell.portrait loadPortrait:friend.portraitURL];
        cell.nameLabel.text = friend.name;
        cell.infoLabel.text = friend.expertise;
        
        return cell;
    } else {
        return self.lastCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        OSCUser *friend = self.objects[indexPath.row];
        self.label.text = friend.name;
        self.label.font = [UIFont systemFontOfSize:16];
        CGSize nameSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)];
        
        self.label.text = friend.expertise;
        self.label.font = [UIFont systemFontOfSize:12];
        CGSize infoLabelSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)];
        
        return nameSize.height + infoLabelSize.height + 21;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCUser *friend = self.objects[row];
        UserDetailsViewController *userDetailsVC = [[UserDetailsViewController alloc] initWithUserID:friend.userID];
        [self.navigationController pushViewController:userDetailsVC animated:YES];
    } else {
        [self fetchMore];
    }
}



@end
