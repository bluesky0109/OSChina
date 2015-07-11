//
//  SearchViewController.m
//  OSChina
//
//  Created by sky on 15/7/11.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"
#import "Utils.h"

@interface SearchViewController ()<UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchViewController

- (instancetype)init {
    self = [super initWithTitle:nil
                   andSubTitles:@[@"软件", @"问答", @"博客", @"新闻"]
                 andControllers:@[
                                  [[SearchResultsViewController alloc] initWithType:@"software"],
                                  [[SearchResultsViewController alloc] initWithType:@"post"],
                                  [[SearchResultsViewController alloc] initWithType:@"blog"],
                                  [[SearchResultsViewController alloc] initWithType:@"news"]
                                  ]];
    if (self) {
        __weak typeof(self) weakSelf = self;
        for (SearchResultsViewController *searchResultVC in self.viewPager.childViewControllers) {
            searchResultVC.viewDidScroll = ^ {
                [weakSelf.searchBar resignFirstResponder];
            };
        }
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _searchBar = [UISearchBar new];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入关键字";

    self.navigationItem.titleView = _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        return;
    }
    
    [searchBar resignFirstResponder];
    
    for (SearchResultsViewController *searchVC in self.viewPager.childViewControllers) {
        searchVC.keyword = searchBar.text;
        [searchVC refresh];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewPager.tableView reloadData];
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

@end
