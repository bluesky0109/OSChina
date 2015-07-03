//
//  SoftwareCatalogVC.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "SoftwareCatalogVC.h"
#import "OSCSoftwareCatalog.h"
#import "OSCAPI.h"
#import "UIColor+Util.h"
#import "SoftwareListVC.h"

static NSString * const kSoftwareCatalogCellID = @"SoftwareCatalogCell";


@interface SoftwareCatalogVC ()

@property (nonatomic, assign) int tag;

@end

@implementation SoftwareCatalogVC

- (instancetype)initWithTag:(int)tag
{
    self = [super init];
    if (!self) {return nil;}
    
    _tag = tag;
    
    self.generateURL = ^NSString * (NSUInteger page) {
        return [NSString stringWithFormat:@"%@%@?tag=%d&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_SOFTWARECATALOG_LIST, tag, (unsigned long)page, OSCAPI_SUFFIX];
    };
    
    self.objClass = [OSCSoftwareCatalog class];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSoftwareCatalogCellID];
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"softwareTypes"] childrenWithTag:@"softwareType"];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSoftwareCatalogCellID forIndexPath:indexPath];
        OSCSoftwareCatalog *softwareCatalog = self.objects[indexPath.row];
        
        cell.backgroundColor = [UIColor themeColor];
        cell.textLabel.text = softwareCatalog.name;
        
        return cell;
    } else {
        return self.lastCell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        return 60;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCSoftwareCatalog *softwareCatalog = self.objects[indexPath.row];
        if (_tag == 0) {
            SoftwareCatalogVC *softwareCatalogVC = [[SoftwareCatalogVC alloc] initWithTag:softwareCatalog.tag];
            [self.navigationController pushViewController:softwareCatalogVC animated:YES];
        } else {
            SoftwareListVC *softwareListVC = [[SoftwareListVC alloc] initWIthSearchTag:softwareCatalog.tag];
            [self.navigationController pushViewController:softwareListVC animated:YES];
        }
    } else {
        [self fetchMore];
    }
}


@end
