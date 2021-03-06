//
//  OSCTabBarController.m
//  OSChina
//
//  Created by sky on 15/6/30.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "OSCTabBarController.h"
#import "SwipableViewController.h"
#import "TweetsViewController.h"
#import "PostsViewController.h"
#import "NewsViewController.h"
#import "BlogsViewController.h"
#import "LoginViewController.h"
#import "DiscoverTableVC.h"
#import "MyInfoViewController.h"
#import "TweetEditingVC.h"
#import "PersonSearchViewController.h"
#import "ScanViewController.h"
#import "ShakingViewController.h"
#import "SearchViewController.h"
#import "VoiceTweetEditingVC.h"
#import "Utils.h"
#import "Config.h"

#import "OptionButton.h"
#import "UIBarButtonItem+Badge.h"

#import <RESideMenu/RESideMenu.h>

@interface OSCTabBarController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, assign) BOOL isPressed;

@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGGlyph length;       //按钮直径

@end

@implementation OSCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSLog(@"just for test");
    [self loadViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)loadViewControllers {
    NewsViewController *newsViewCtl = [[NewsViewController alloc]  initWithNewsListType:NewsListTypeNews];
    NewsViewController *hotNewsViewCtl = [[NewsViewController alloc]  initWithNewsListType:NewsListTypeAllTypeWeekHottest];
    BlogsViewController *blogViewCtl = [[BlogsViewController alloc] initWithBlogsType:BlogsTypeLatest];
    BlogsViewController *recommendBlogViewCtl = [[BlogsViewController alloc] initWithBlogsType:BlogsTypeRecommended];

    TweetsViewController *newTweetViewCtl = [[TweetsViewController alloc] initWithTweetsType:TweetsTypeAllTweets];
    TweetsViewController *hotTweetViewCtl = [[TweetsViewController alloc] initWithTweetsType:TweetsTypeHotestTweets];
    TweetsViewController *myTweetViewCtl = [[TweetsViewController alloc] initWithTweetsType:TweetsTypeOwnTweets];

    newsViewCtl.needCache = YES;
    hotNewsViewCtl.needCache = YES;
    blogViewCtl.needCache = YES;
    recommendBlogViewCtl.needCache = YES;

    newTweetViewCtl.needCache = YES;
    hotTweetViewCtl.needCache = YES;
    myTweetViewCtl.needCache = YES;
    
    SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:@"综合"
                                                                         andSubTitles:@[@"资讯", @"热点", @"博客", @"推荐"]
                                                                       andControllers:@[newsViewCtl, hotNewsViewCtl, blogViewCtl,recommendBlogViewCtl] underTabbar:YES];

    SwipableViewController *tweetsSVC = [[SwipableViewController alloc] initWithTitle:@"动弹"
                                                                           andSubTitles:@[@"最新动弹", @"热门动弹", @"我的动弹"]
                                                                         andControllers:@[newTweetViewCtl, hotTweetViewCtl, myTweetViewCtl] underTabbar:YES];

    DiscoverTableVC *discoverVC = [[DiscoverTableVC alloc] initWithStyle:UITableViewStyleGrouped];

    MyInfoViewController *myInfoVC = [[MyInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    self.viewControllers = @[
                             [self addNavigationItemForViewController:newsSVC],
                             [self addNavigationItemForViewController:tweetsSVC],
                             [UIViewController new],
                             [self addNavigationItemForViewController:discoverVC],
                             [[UINavigationController alloc] initWithRootViewController:myInfoVC]
                            ];
    
    NSArray *titles = @[@"综合", @"动弹", @"", @"发现", @"我"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"", @"tabbar-discover", @"tabbar-me"];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];
    
    [self.tabBar.items[2] setEnabled:NO];
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];
    
    [self.tabBar addObserver:self forKeyPath:@"selectedItem" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    // 功能键相关
    _optionButtons = [NSMutableArray new];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    _length = 60;
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSArray *buttonTitles = @[@"文字", @"相册", @"拍照", @"语音", @"扫一扫", @"找人"];
    NSArray *buttonImages = @[@"tweetEditing", @"picture", @"shooting", @"sound", @"scan", @"search"];
    int buttonColors[] = {0xe69961, 0x0dac6b, 0x24a0c4, 0xe96360, 0x61b644, 0xf1c50e};
    
    for (int i = 0; i < 6; i++) {
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:buttonTitles[i]
                                                                   image:[UIImage imageNamed:buttonImages[i]]
                                                                andColor:[UIColor colorWithHex:buttonColors[i]]];
        
        optionButton.frame = CGRectMake((_screenWidth/6 * (i%3*2+1) - (_length+16)/2), _screenHeight + 150 + i/3*100,
                                        _length + 16, _length + [UIFont systemFontOfSize:14].lineHeight + 24);
        [optionButton.button setCornerRadius:_length/2];
        
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        
        [self.view addSubview:optionButton];
        [_optionButtons addObject:optionButton];
    }    
}


- (void)addCenterButtonWithImage:(UIImage *)buttonImage {
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height -4);
    
#if 0
    _centerButton.frame = CGRectMake(origin.x - buttonSize.width / 2,origin.y - buttonSize.height/2, buttonSize.width, buttonSize.height);
    [_centerButton setCornerRadius:5.0];
#else
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height / 2,origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    [_centerButton setCornerRadius:buttonSize.height/2];
#endif
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x24a83d]];
    
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:_centerButton];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedItem"]) {
        if (self.isPressed) {
            [self buttonPressed];
        }
    }
}

- (void)buttonPressed {
    [self changeTheButtonStateAnimatedToOpen:_isPressed];
    
    _isPressed = !_isPressed;
}

- (void)changeTheButtonStateAnimatedToOpen:(BOOL)isPressed {
    if (isPressed) {
        [self removeBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight + 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC * (6 - i)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    } else {
        [self addBlurView];
        
        [_animator removeAllBehaviors];
        
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            [self.view bringSubviewToFront:button];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight - 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC * (i+1)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    }
}


- (void)addBlurView {
    _centerButton.enabled = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect cropRect = CGRectMake(0, screenSize.height - 270, screenSize.width, screenSize.height);

    UIImage *originalImage = [self.view updateBlur];
    UIImage *croppedBlurImage = [originalImage cropToRect:cropRect];

    _blurView = [[UIImageView alloc] initWithImage:croppedBlurImage];
    _blurView.frame = cropRect;
    _blurView.userInteractionEnabled = YES;
    [self.view addSubview:_blurView];
    
    _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.alpha = 0.4;
    [self.view insertSubview:_dimView belowSubview:self.tabBar];

    [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    [_dimView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    
    [UIView animateWithDuration:0.25f animations:nil completion:^(BOOL finished) {
        if (finished) {
            _centerButton.enabled = YES;
        }
    }];
}

- (void)removeBlurView {
    _centerButton.enabled = NO;
    self.view.alpha = 1;
    
    [UIView animateWithDuration:0.25f animations:nil completion:^(BOOL finished) {
        if (finished) {
            [_dimView removeFromSuperview];
            _dimView = nil;
            [self.blurView removeFromSuperview];
            self.blurView = nil;
            _centerButton.enabled = YES;
        }
    }];
}

- (void)onTapOptionButton:(UIGestureRecognizer *)recognizer {
    switch (recognizer.view.tag) {
        case 0: {
            TweetEditingVC *tweetEditingVC = [TweetEditingVC new];
            UINavigationController *tweetEditingNav = [[UINavigationController alloc] initWithRootViewController:tweetEditingVC];
            
            [self.selectedViewController presentViewController:tweetEditingNav animated:YES completion:nil];
            break;
        }
         
        case 1: {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = NO;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
            break;
        }

        case 2: {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            } else {
                UIImagePickerController *imagePcikerController = [UIImagePickerController new];
                imagePcikerController.delegate = self;
                imagePcikerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePcikerController.allowsEditing = NO;
                imagePcikerController.showsCameraControls = YES;
                imagePcikerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                imagePcikerController.mediaTypes = @[(NSString *)kUTTypeImage];
                
                [self presentViewController:imagePcikerController animated:YES completion:nil];
            }
            break;
        }

        case 3: {
//            ShakingViewController *shakingVC = [ShakingViewController new];
//            UINavigationController *shakingNav = [[UINavigationController alloc] initWithRootViewController:shakingVC];
//            [self.selectedViewController presentViewController:shakingNav animated:YES completion:nil];

            VoiceTweetEditingVC *voiceTweetVC = [VoiceTweetEditingVC new];
            UINavigationController *voiceTweetNav = [[UINavigationController alloc] initWithRootViewController:voiceTweetVC];
            [self.selectedViewController presentViewController:voiceTweetNav animated:NO completion:nil];
            
            break;
        }

        case 4: {
            ScanViewController *scanVC = [ScanViewController new];
            UINavigationController *scanNav = [[UINavigationController alloc] initWithRootViewController:scanVC];
            [self.selectedViewController presentViewController:scanNav animated:YES completion:nil];

            break;
        }

        case 5: {
            PersonSearchViewController *personSearchVC = [PersonSearchViewController new];
            UINavigationController *personSearchNav = [[UINavigationController alloc] initWithRootViewController:personSearchVC];
            [self.selectedViewController presentViewController:personSearchNav animated:YES completion:nil];

            break;
        }

        default:
            break;
    }
    
    [self buttonPressed];
}

#pragma mark -

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController {
    UINavigationController *navigationCtl = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMenuButton)];
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-search"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSearchViewController)];
    
    return navigationCtl;
}



#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (self.selectedIndex <= 1 && self.selectedIndex == [tabBar.items indexOfObject:item]) {
        SwipableViewController *swipeableVC = (SwipableViewController *)((UINavigationController *)self.selectedViewController).viewControllers[0];
        OSCObjsViewController *objsVC = (OSCObjsViewController *)swipeableVC.viewPager.childViewControllers[swipeableVC.titleBar.currentIndex];
        

        [objsVC.tableView setContentOffset:CGPointMake(0, -objsVC.refreshControl.frame.size.height) animated:NO];
        [objsVC.refreshControl beginRefreshing];
        
        [objsVC refresh];
    }
}

#pragma mark - 处理左右navigationItem点击事件
- (void)pushSearchViewController {
   [(UINavigationController *)self.selectedViewController pushViewController:[SearchViewController new] animated:YES];
}

- (void)onClickMenuButton {
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:NO completion:^{
        TweetEditingVC *tweetEditingVC = [[TweetEditingVC alloc] initWithImage:info[UIImagePickerControllerOriginalImage]];;
        UINavigationController *tweetEditNav = [[UINavigationController alloc] initWithRootViewController:tweetEditingVC];
        [self.selectedViewController presentViewController:tweetEditNav animated:NO completion:nil];
        
        [self buttonPressed];
    }];
}


@end
