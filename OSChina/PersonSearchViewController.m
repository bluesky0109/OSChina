//
//  PersonSearchViewController.m
//  OSChina
//
//  Created by sky on 15/7/9.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "PersonSearchViewController.h"
#import "PeopleTableViewController.h"

@interface PersonSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) PeopleTableViewController *resultsTableVC;

@end

@implementation PersonSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"找人";
    
    [self initSubviews];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initSubviews {
    _searchBar = [UISearchBar new];
    _searchBar.placeholder = @"输入用户昵称";
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    [_searchBar becomeFirstResponder];
    
    _resultsTableVC = [PeopleTableViewController new];
    [self addChildViewController:_resultsTableVC];
    [self.view addSubview:_resultsTableVC.tableView];
}

- (void)setLayout {
    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSDictionary *views = @{@"_searchBar": _searchBar, @"resultsTable": _resultsTableVC.tableView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_searchBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_searchBar][resultsTable]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
}

@end
