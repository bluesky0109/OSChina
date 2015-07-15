//
//  PresentMembersViewController.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "PresentMembersViewController.h"
#import "OSCEventPersonInfo.h"
#import "OSCAPI.h"
#import "PersonCell.h"
#import "UserDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const kPersonCellID = @"PersonCell";

@interface PresentMembersViewController ()

@end

@implementation PresentMembersViewController

- (instancetype)initWithEventID:(int64_t)eventID {
    self = [super init];
    if (self) {
        self.generateURL = ^NSString *(NSUInteger page) {
             return [NSString stringWithFormat:@"%@%@?event_id=%lld&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_EVENT_ATTEND_USER, eventID, (unsigned long)page, OSCAPI_SUFFIX];
        };
        
        self.objClass = [OSCEventPersonInfo class];
        
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PersonCell class] forCellReuseIdentifier:kPersonCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"applies"] childrenWithTag:@"apply"];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < self.objects.count) {
        OSCEventPersonInfo *person = self.objects[row];
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonCellID forIndexPath:indexPath];
        
        [cell.portrait loadPortrait:person.portraitURL];
        cell.nameLabel.text = person.userName;
        cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@",person.company, person.job];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        OSCEventPersonInfo *person = self.objects[indexPath.row];
        self.label.text = person.userName;
        self.label.font = [UIFont systemFontOfSize:16];
        CGSize nameSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)];
        
        self.label.text = [NSString stringWithFormat:@"%@ %@",person.company, person.job];
        self.label.font = [UIFont systemFontOfSize:12];
        CGSize infoSize = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)];
        
        return nameSize.height + infoSize.height + 21;
        
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCEventPersonInfo *person = self.objects[row];
        
        UserDetailsViewController *userDetailsVC = [[UserDetailsViewController alloc] initWithUserID:person.userID];
        [self.navigationController pushViewController:userDetailsVC animated:YES];
    } else {
        [self fetchMore];
    }
}



@end
