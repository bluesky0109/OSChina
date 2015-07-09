//
//  PersonSearchViewController.m
//  OSChina
//
//  Created by sky on 15/7/9.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "PersonSearchViewController.h"

@interface PersonSearchViewController ()<UISearchResultsUpdating>

@end

@implementation PersonSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResultsUpdater = self;
    self.dimsBackgroundDuringPresentation = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}



@end
