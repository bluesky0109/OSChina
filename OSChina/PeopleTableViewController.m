//
//  PeopleTableViewController.m
//  OSChina
//
//  Created by sky on 15/7/9.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "PeopleTableViewController.h"
#import "UserDetailsViewController.h"
#import "OSCUser.h"
#import "PersonCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


static NSString * const kPersonCellID = @"PersonCell";

@interface PeopleTableViewController ()

@end

@implementation PeopleTableViewController

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    __weak PeopleTableViewController *weakSelf = self;
    self.generateURL = ^NSString *(NSUInteger page) {
        return [NSString stringWithFormat:@"%@%@?name=%@&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_SEARCH_USERS, weakSelf.queryString, (unsigned long)page, OSCAPI_SUFFIX];
    };
    self.objClass = [OSCUser class];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"users"] childrenWithTag:@"user"];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < self.objects.count) {
        OSCUser *user = self.objects[row];
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonCellID forIndexPath:indexPath];
        
        [cell.portrait sd_setImageWithURL:user.portraitURL placeholderImage:nil];
        cell.nameLabel.text = user.name;
        cell.infoLabel.text = user.location;
        
        return cell;
    } else {
        return self.lastCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        OSCUser *friend = self.objects[indexPath.row];
        self.label.text = friend.name;
        self.label.font = [UIFont systemFontOfSize:16];
        CGSize nameSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)];
        
        self.label.text = friend.location;
        self.label.font = [UIFont systemFontOfSize:12];
        CGSize infoLabelSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)];
        
        return nameSize.height + infoLabelSize.height + 21;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCUser *user = self.objects[row];
        UserDetailsViewController *userDetailsVC = [[UserDetailsViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:userDetailsVC animated:YES];
    } else {
        [self fetchMore];
    }
    
}

@end
