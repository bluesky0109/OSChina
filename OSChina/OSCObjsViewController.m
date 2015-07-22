//
//  OSCObjsViewController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCObjsViewController.h"
#import "OSCBaseObject.h"
#import <MBProgressHUD.h>

@interface OSCObjsViewController ()

@property (nonatomic, assign) BOOL refreshInProgress;

@end

@implementation OSCObjsViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.objects = [NSMutableArray new];
        _page = 0;
        _needRefreshAnimation = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.lastCell = [[LastCell alloc] initCell];
    
    //用于计算cell高度
    self.label = [UILabel new];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.font = [UIFont boldSystemFontOfSize:14];
    
    //自动进入刷新 刷新动画
    if (_needRefreshAnimation) {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height)
                                animated:YES];
    }

    [self fetchObjectsOnPage:0 refresh:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.lastCell.status == LastCellStatusNotVisible || _objects.count == 0) {
        return self.objects.count;
    }
    
    return self.objects.count + 1;
}

#pragma mark -- UITableViewDelegate
/*
// 这个方法会导致reloadData时，tableview自动滑动到底部
// 暂时还没发现好的解决方法，只好不用这个方法了
// http://stackoverflow.com/questions/22753858/implementing-estimatedheightforrowatindexpath-causes-the-tableview-to-scroll-do

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
*/

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
    [self fetchObjectsOnPage:++_page refresh:NO];
}

#pragma mark - 请求数据

- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    [manager GET:self.generateURL(page)
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
             self.allCount = [[[responseDocument.rootElement firstChildWithTag:@"allCount"] numberValue] intValue];
             NSArray *objectsXML = [self parseXML:responseDocument];
             
             if (refresh) {
                 _page = 0;
                 [self.objects removeAllObjects];
                 if (self.didRefreshSucceed) {
                     self.didRefreshSucceed();
                 }
             }
             
             if (self.parseExtraInfo) {
                 self.parseExtraInfo(responseDocument);
             }
             
             for (ONOXMLElement *objXML in objectsXML) {
                 BOOL shouldBeAdded = YES;
                 id obj = [[self.objClass alloc] initWithXML:objXML];
                 
                 for (OSCBaseObject *baseObj in self.objects) {
                     if ([obj isEqual:baseObj]) {
                         shouldBeAdded = NO;
                         break;
                     }
                 }
                 if (shouldBeAdded) {
                     [self.objects addObject:obj];
                 }
            }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self.tableWillReload) {
                     self.tableWillReload(objectsXML.count);
                 } else {
                     if (objectsXML.count == 0 ||(_page == 0 && objectsXML.count < 20)) {
                         [self.lastCell statusFinished];
                     } else {
                         [self.lastCell statusMore];
                     }
                 }
                 
                 [self.tableView reloadData];
                 if (refresh) {
                     [self.refreshControl endRefreshing];
                     [self.tableView setContentOffset:CGPointZero animated:YES];
                 }
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MBProgressHUD *HUD = [Utils createHUD];
             HUD.mode = MBProgressHUDModeCustomView;
             HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
             HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
             
             [HUD hide:YES afterDelay:1];
             
             [self.lastCell statusError];
             [self.tableView reloadData];
             if (refresh) {
                 [self.refreshControl endRefreshing];
                 [self.tableView setContentOffset:CGPointZero animated:YES];
             }
         }
     ];
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {
    NSAssert(false, @"Override in subclasses");
    return nil;
}

@end
