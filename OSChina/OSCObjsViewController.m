//
//  OSCObjsViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"
#import "OSCBaseObject.h"

@interface OSCObjsViewController ()

@property (nonatomic, assign) BOOL refreshInProgress;

@end

@implementation OSCObjsViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.objects = [NSMutableArray new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor themeColor];
    UIView *footer = [UIView new];
    self.tableView.tableFooterView = footer;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.lastCell = [[LastCell alloc] initCell];
    
    //用于计算cell高度
    self.label = [UILabel new];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.font = [UIFont boldSystemFontOfSize:14];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.objects.count > 0 || self.lastCell.status == LastCellStatusFinished) {
        return;
    }
    
    //无数据或未加载完自动进入刷新
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
    [self fetchObjectsOnPage:0 refresh:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.lastCell.status == LastCellStatusNotVisible) {
        return self.objects.count;
    }
    
    return self.objects.count + 1;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - 刷新

- (void)refresh
{
    _refreshInProgress = NO;
    
    if (!_refreshInProgress)
    {
        _refreshInProgress = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchObjectsOnPage:0 refresh:YES];
            _refreshInProgress = NO;
        });
    }
}




#pragma mark - 上拉加载更多

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        [self fetchMore];
    }
}

- (void)fetchMore
{
    if (self.lastCell.status == LastCellStatusFinished || self.lastCell.status == LastCellStatusLoading) {return;}
    
    [self.lastCell statusLoading];
    [self fetchObjectsOnPage:(self.objects.count + 19)/20 refresh:NO];
}





#pragma mark - 请求数据

- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh
{
#if 0
    if (![Tools isNetworkExist]) {
        if (refresh) {
            [self.refreshControl endRefreshing];
        } else {
            _isLoading = NO;
            if (_isFinishedLoad) {
                [_lastCell finishedLoad];
            } else {
                [_lastCell normal];
            }
        }
        [Tools toastNotification:@"网络连接失败，请检查网络设置" inView:self.parentViewController.view];
        return;
    }
#endif
    
    if (!refresh) {[self.lastCell statusLoading];}
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    [manager GET:self.generateURL(page)
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
             self.allCount = [[[responseDocument.rootElement firstChildWithTag:@"allCount"] numberValue] intValue];
             NSArray *objectsXML = [self parseXML:responseDocument];
             
             if (refresh) {[self.objects removeAllObjects];}
             
             /* 这里要添加一个去重步骤 */
             
             for (ONOXMLElement *objXML in objectsXML) {
                 id obj = [[self.objClass alloc] initWithXML:objXML];
                 [self.objects addObject:obj];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self.tableWillReload) {
                     self.tableWillReload(objectsXML.count);
                 } else {
                     objectsXML.count < 20? [self.lastCell statusFinished] : [self.lastCell statusMore];
                 }
                 
                 [self.tableView reloadData];
                 if (refresh) {[self.refreshControl endRefreshing];}
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"网络异常，错误码：%ld", (long)error.code);
             
             [self.lastCell statusError];
             [self.tableView reloadData];
             if (refresh) {
                 [self.refreshControl endRefreshing];
             }
         }
     ];
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    NSAssert(false, @"Override in subclasses");
    return nil;
}

@end
