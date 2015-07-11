//
//  DetailsViewController.m
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "DetailsViewController.h"
#import "OSCAPI.h"
#import "OSCNews.h"
#import "OSCBlog.h"
#import "OSCPost.h"
#import "OSCSoftware.h"
#import "OSCNewsDetails.h"
#import "OSCBlogDetails.h"
#import "OSCPostDetails.h"
#import "OSCSoftwareDetails.h"
#import "CommentsBottomBarViewController.h"
#import "TweetsViewController.h"
#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>

#import "Utils.h"


#define HTML_STYLE @"<style>#oschina_title {color: #000000; margin-bottom: 6px; font-weight:bold;}#oschina_title img{vertical-align:middle;margin-right:6px;}#oschina_title a{color:#0D6DA8;}#oschina_outline {color: #707070; font-size: 12px;}#oschina_outline a{color:#0D6DA8;}#oschina_software{color:#808080;font-size:12px}#oschina_body img {max-width: 300px;}#oschina_body {font-size:16px;max-width:300px;line-height:24px;} #oschina_body table{max-width:300px;}#oschina_body pre { font-size:9pt;font-family:Courier New,Arial;border:1px solid #ddd;border-left:5px solid #6CE26C;background:#f6f6f6;padding:5px;}</style>"

#define HTML_BOTTOM @"<div style='margin-bottom:60px'/>"


@interface DetailsViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, assign) int64_t objectID;
@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, strong) OSCNews   *news;
@property (nonatomic, copy  ) NSString  *detailsURL;
@property (nonatomic, strong) UIWebView *detailsView;
@property (nonatomic, copy  ) NSString  *tag;
@property (nonatomic, assign) SEL       loadMethod;
@property (nonatomic, assign) Class detailsClass;

@end

@implementation DetailsViewController

#pragma mark - 初始化方法
- (instancetype)initWithNews:(OSCNews *)news {
    self = [super initWithModeSwitchButton:YES];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        _news = news;
        _objectID = news.newsID;
        
        switch (news.type) {
            case NewsTypeStandardNews:
                self.navigationItem.title = @"资讯详情";
                _detailsURL = [NSString stringWithFormat:@"%@%@?id=%lld", OSCAPI_PREFIX, OSCAPI_NEWS_DETAIL, news.newsID];
                _tag = @"news";
                _commentType = CommentTypeNews;
                _detailsClass = [OSCNewsDetails class];
                _loadMethod = @selector(loadNewsDetails:);
                break;
            case NewsTypeSoftWare:
                self.navigationItem.title = @"软件详情";
                _detailsURL = [NSString stringWithFormat:@"%@%@?ident=%@", OSCAPI_PREFIX, OSCAPI_SOFTWARE_DETAIL, news.attachment];
                _tag = @"software";
                _commentType = CommentTypeSoftware;
                _detailsClass = [OSCSoftwareDetails class];
                _loadMethod = @selector(loadSoftwareDetails:);
                break;
            case NewsTypeQA:
                self.navigationItem.title = @"帖子详情";
                _detailsURL = [NSString stringWithFormat:@"%@%@?id=%@", OSCAPI_PREFIX, OSCAPI_POST_DETAIL, news.attachment];
                _tag = @"post";
                _objectID = [news.attachment longLongValue];
                _commentType = CommentTypePost;
                _detailsClass = [OSCPostDetails class];
                _loadMethod = @selector(loadPostDetails:);
                break;
            case NewsTypeBlog:
                self.navigationItem.title = @"博客详情";
                _detailsURL = [NSString stringWithFormat:@"%@%@?id=%@", OSCAPI_PREFIX, OSCAPI_BLOG_DETAIL, news.attachment];
                _tag = @"blog";
                _commentType = CommentTypeBlog;
                _detailsClass = [OSCBlogDetails class];
                _loadMethod = @selector(loadBlogDetails:);
                break;
            default:
                break;

        }

    }
    
    return self;
}

- (instancetype)initWithBlog:(OSCBlog *)blog
{
    self = [super initWithModeSwitchButton:YES];
    if (self) {
        _commentType = CommentTypeBlog;
        _objectID = blog.blogID;
        
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = @"博客详情";
        _detailsURL = [NSString stringWithFormat:@"%@%@?id=%lld", OSCAPI_PREFIX, OSCAPI_BLOG_DETAIL, blog.blogID];
        _tag = @"blog";
        _detailsClass = [OSCBlogDetails class];
        _loadMethod = @selector(loadBlogDetails:);
    }
    
    return self;
}

- (instancetype)initWithPost:(OSCPost *)post {
    self = [super initWithModeSwitchButton:YES];
    
    if (!self) {return nil;}
    
    _commentType = CommentTypePost;
    _objectID = post.postID;
    
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"帖子详情";
    _detailsURL = [NSString stringWithFormat:@"%@%@?id=%lld", OSCAPI_PREFIX, OSCAPI_POST_DETAIL, post.postID];
    _tag = @"post";
    _detailsClass = [OSCPostDetails class];
    _loadMethod = @selector(loadPostDetails:);
    
    return self;
}

- (instancetype)initWithSoftware:(OSCSoftware *)software {
    self = [super initWithModeSwitchButton:YES];
    if (self) {
        
        _commentType = CommentTypeSoftware;
        
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = @"软件详情";
        _detailsURL = [NSString stringWithFormat:@"%@%@?ident=%@", OSCAPI_PREFIX, OSCAPI_SOFTWARE_DETAIL, software.url.absoluteString.lastPathComponent];
        _tag = @"software";
        _detailsClass = [OSCSoftwareDetails class];
        _loadMethod = @selector(loadSoftwareDetails:);
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    _detailsView = [UIWebView new];
    _detailsView.delegate = self;
    _detailsView.scrollView.delegate = self;
    _detailsView.scrollView.bounces = NO;
    _detailsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_detailsView];
    [self.view bringSubviewToFront:(UIView *)self.editingBar];
    
    [self setBlockForOperationBar];
    
    NSDictionary *views = @{@"detailsView": _detailsView, @"bottomBar": self.editingBar};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailsView][bottomBar]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[detailsView]|" options:0 metrics:nil views:views]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    [manager GET:self.detailsURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
             ONOXMLElement *XML = [responseDocument.rootElement firstChildWithTag:self.tag];
             
             id details = [[self.detailsClass alloc] initWithXML:XML];
             [self performSelector:_loadMethod withObject:details];
             
             if (_commentType == CommentTypeSoftware) {
                 _objectID = ((OSCSoftwareDetails *)details).softwareID;
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"网络异常，错误码：%ld", (long)error.code);
         }
     ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)setBlockForOperationBar {
    __weak typeof(self) weakSelf = self;
    
    self.operationBar.toggleStar = ^ {
        
    };
    
    self.operationBar.showComments = ^ {
        if (weakSelf.commentType == CommentTypeSoftware) {
            TweetsViewController *tweetsVC = [[TweetsViewController alloc] initWIthSoftwareID:weakSelf.objectID];
            [weakSelf.navigationController pushViewController:tweetsVC animated:YES];
        } else {
            CommentsBottomBarViewController *commentsBVC = [[CommentsBottomBarViewController alloc] initWithCommentType:weakSelf.commentType andObjectID:weakSelf.objectID];
            [weakSelf.navigationController pushViewController:commentsBVC animated:YES];
        }
    };
    
    self.operationBar.share = ^ {
        
    };
    
    self.operationBar.report = ^ {
        
    };
    
}


#pragma mark --private
- (void)loadNewsDetails:(OSCNewsDetails *)newsDetails
{
    NSString *authorStr = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%lld'>%@</a> 发布于 %@", newsDetails.authorID, newsDetails.author, newsDetails.pubDate];
    
    NSString *software = @"";
    if ([newsDetails.softwareName isEqualToString:@""] == NO) {
        software = [NSString stringWithFormat:@"<div id='oschina_software' style='margin-top:8px;color:#FF0000;font-size:14px;font-weight:bold'>更多关于:&nbsp;<a href='%@'>%@</a>&nbsp;的详细信息</div>", newsDetails.softwareLink, newsDetails.softwareName];
    }
    
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@%@%@</body>", HTML_STYLE, newsDetails.title, authorStr, newsDetails.body, software, [Utils generateRelativeNewsString:newsDetails.relatives], HTML_BOTTOM];
    
    [self.detailsView loadHTMLString:html baseURL:nil];
    _isStarred = newsDetails.isFavorite;
}

- (void)loadBlogDetails:(OSCBlogDetails *)blogDetails
{
    NSString *authorStr = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%lld'>%@</a>&nbsp;发表于&nbsp;%@", blogDetails.authorID, blogDetails.author,  [Utils intervalSinceNow:blogDetails.pubDate]];
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@</body>",HTML_STYLE, blogDetails.title, authorStr, blogDetails.body, HTML_BOTTOM];
    
    [self.detailsView loadHTMLString:html baseURL:nil];
    _isStarred = blogDetails.isFavorite;
}

- (void)loadSoftwareDetails:(OSCSoftwareDetails *)softwareDetails
{
    NSString *titleStr = [NSString stringWithFormat:@"%@ %@", softwareDetails.extensionTitle, softwareDetails.title];
    
    NSString *tail = [NSString stringWithFormat:@"<div><table><tr><td style='font-weight:bold'>授权协议:&nbsp;</td><td>%@</td></tr><tr><td style='font-weight:bold'>开发语言:</td><td>%@</td></tr><tr><td style='font-weight:bold'>操作系统:</td><td>%@</td></tr><tr><td style='font-weight:bold'>收录时间:</td><td>%@</td></tr></table></div>", softwareDetails.license, softwareDetails.language, softwareDetails.os, softwareDetails.recordTime];
    
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'><img src='%@' width='34' height='34'/>%@</div><hr/><div id='oschina_body'>%@</div><div>%@</div>%@%@</body>", HTML_STYLE, softwareDetails.logoURL, titleStr, softwareDetails.body, tail, [self createButtonsWithHomepageURL:softwareDetails.homepageURL andDocumentURL:softwareDetails.documentURL andDownloadURL:softwareDetails.downloadURL], HTML_BOTTOM];
    
    [self.detailsView loadHTMLString:html baseURL:nil];
    _isStarred = softwareDetails.isFavorite;
}

- (NSString *)createButtonsWithHomepageURL:(NSString *)homepageURL andDocumentURL:(NSString *)documentURL andDownloadURL:(NSString *)downloadURL
{
    NSString *strHomePage = @"";
    NSString *strDocument = @"";
    NSString *strDownload = @"";
    
    if ([homepageURL isEqualToString:@""] == NO) {
        strHomePage = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件首页' style='font-size:14px;'/></a>", homepageURL];
    }
    if ([documentURL isEqualToString:@""] == NO) {
        strDocument = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件文档' style='font-size:14px;'/></a>", documentURL];
    }
    if ([downloadURL isEqualToString:@""] == NO) {
        strDownload = [NSString stringWithFormat:@"<a href=%@><input type='button' value='软件下载' style='font-size:14px;'/></a>", downloadURL];
    }
    
    return [NSString stringWithFormat:@"<p>%@&nbsp;&nbsp;%@&nbsp;&nbsp;%@</p>", strHomePage, strDocument, strDownload];
}

- (void)loadPostDetails:(OSCPostDetails *)postDetails
{
    NSString *authorStr = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%lld'>%@</a> 发布于 %@", postDetails.authorID, postDetails.author, [Utils intervalSinceNow:postDetails.pubDate]];
    
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3;'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@%@</body>",HTML_STYLE, postDetails.title, authorStr, postDetails.body, [Utils GenerateTags:postDetails.tags], HTML_BOTTOM];
    
    [self.detailsView loadHTMLString:html baseURL:nil];
    _isStarred = postDetails.isFavorite;
}

#pragma mark - 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [Utils analysis:[request.URL absoluteString] andNavController:self.navigationController];
    return [request.URL.absoluteString isEqualToString:@"about:blank"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.editingBar.editView resignFirstResponder];
}

@end
