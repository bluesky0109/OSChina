//
//  FavoritesViewController.m
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "FavoritesViewController.h"
#import "DetailsViewController.h"
#import "Config.h"
#import "OSCNews.h"
#import "OSCBlog.h"
#import "OSCPost.h"
#import "Utils.h"

static NSString * const kFavoriteCellID = @"FavoriteCell";

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (instancetype)initWithFavoritesType:(FavoritesType)favoritesType {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.generateURL = ^NSString *(NSUInteger page) {
        return [NSString stringWithFormat:@"%@%@?uid=%llu&type=%d&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_FAVORITE_LIST, [Config getOwnID], favoritesType, (unsigned long)page, OSCAPI_SUFFIX];
    };
    self.objClass = [OSCFavorite class];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kFavoriteCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    return [[xml.rootElement firstChildWithTag:@"favorites"] childrenWithTag:@"favorite"];
}

#pragma mark -UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFavoriteCellID forIndexPath:indexPath];
        OSCFavorite *favorite = self.objects[indexPath.row];
        cell.backgroundColor = [UIColor themeColor];
        
        cell.textLabel.text = favorite.title;
        
        return cell;
    } else {
        return self.lastCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return 50;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCFavorite *favorite = self.objects[row];
        
        [Utils analysis:[favorite.url absoluteString] andNavController:self.navigationController];
        
    } else {
        [self fetchMore];
    }
}

@end
