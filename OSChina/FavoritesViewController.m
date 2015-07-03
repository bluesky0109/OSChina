//
//  FavoritesViewController.m
//  OSChina
//
//  Created by sky on 15/7/3.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Config.h"
#import "OSCNews.h"
#import "OSCBlog.h"
#import "OSCPost.h"
#import "DetailsViewController.h"

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
        
        switch (favorite.type) {
            case FavoritesTypeSoftware: {
                OSCNews *news = [OSCNews new];
                news.type = NewsTypeSoftWare;
                DetailsViewController *detailsVC = [[DetailsViewController alloc] initWithNews:news];
                [self.navigationController pushViewController:detailsVC animated:YES];
                break;
            }
                
            case FavoritesTypeTopic: {
                OSCPost *post = [OSCPost new];
                post.postID = favorite.objectID;
                DetailsViewController *detailsVC = [[DetailsViewController alloc] initWithPost:post];
                [self.navigationController pushViewController:detailsVC animated:YES];
                break;
            }
                
            case FavoritesTypeBlog: {
                OSCBlog *blog = [OSCBlog new];
                blog.blogID = favorite.objectID;
                DetailsViewController *detailsVC = [[DetailsViewController alloc] initWithBlog:blog];
                [self.navigationController pushViewController:detailsVC animated:YES];
                break;
            }
                
            case FavoritesTypeNews: {
                OSCNews *news = [OSCNews new];
                news.type = NewsTypeStandardNews;
                DetailsViewController *detailsVC = [[DetailsViewController alloc] initWithNews:news];
                [self.navigationController pushViewController:detailsVC animated:YES];
                break;
            }
                
            case FavoritesTypeCode: {
                [[UIApplication sharedApplication] openURL:favorite.url];
                break;
            }
                
            default:
                break;
        }
    
        
        
    } else {
        [self fetchMore];
    }
}

@end
