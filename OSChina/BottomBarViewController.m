//
//  BottomBarViewController.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "BottomBarViewController.h"
#import "BottomBar.h"
#import "GrowingTextView.h"
#import "EmojiPageVC.h"

@interface BottomBarViewController ()

@end

@implementation BottomBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBottomBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidUpdate:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBottomBar {
    _bottomBar = [BottomBar new];
    _bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bottomBar];
    
    //_emojiPanel = [[EmojiPanelView alloc] initWithPanelHeight:150];
    //_emojiPanel.translatesAutoresizingMaskIntoConstraints = NO;
    //[self.view addSubview:_emojiPanel];
    
//    _emojiPanelVC = [[EmojiPageVC alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    [self addChildViewController:_emojiPanelVC];
//    [self.view addSubview:_emojiPanelVC.view];


    _bottomBarYContraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    _bottomBarHeightContraint = [NSLayoutConstraint constraintWithItem:_bottomBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[self minimumInputbarHeight]];
    
    [self.view addConstraint:_bottomBarYContraint];
    [self.view addConstraint:_bottomBarHeightContraint];
    
#if 0
    //CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    //NSDictionary *metrics = @{@"panelWidth": @(screenWidth * 5)};
    _emojiPanel = _emojiPanelVC.view;
    [self.view addSubview:_emojiPanel];
    NSDictionary *views = NSDictionaryOfVariableBindings(_emojiPanel);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_emojiPanel]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_emojiPanel(150)]|" options:0 metrics:nil views:views]];
#endif
}

- (GrowingTextView *)textView {
    return self.bottomBar.editView;
}

- (CGFloat)minimumInputbarHeight {
    return self.bottomBar.intrinsicContentSize.height;
}

- (CGFloat)deltaInputbarHeight {
    return self.bottomBar.intrinsicContentSize.height - self.textView.font.lineHeight;
}

- (CGFloat)barHeightForLines:(NSUInteger)numberOfLines {
    CGFloat height = [self deltaInputbarHeight];
    
    height += roundf(self.textView.font.lineHeight * numberOfLines);

    return height;
}

- (CGFloat)appropriateInputbarHeight {
    CGFloat height = 0.0;
    CGFloat minimumHeight = [self minimumInputbarHeight];
    NSUInteger numberOfLines = self.textView.numberOfLines;
    
    if (numberOfLines == 1) {
        height = minimumHeight;
    } else if (numberOfLines < self.textView.maxNumberOfLines) {
        height = [self barHeightForLines:self.textView.numberOfLines];
    } else {
        height = [self barHeightForLines:self.textView.maxNumberOfLines];
    }
    
    if (height < minimumHeight) {
        height = minimumHeight;
    }
    
    return height;
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _bottomBarYContraint.constant = keyboardBounds.size.height;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _bottomBarYContraint.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)textDidUpdate:(NSNotification *)notification {
    CGFloat inputbarHeight = [self appropriateInputbarHeight];
    
    if (inputbarHeight != self.bottomBarHeightContraint.constant) {
        self.bottomBarHeightContraint.constant = inputbarHeight;
        
#if 0
        if (animated) {
            
            //BOOL bounces = self.bounces && [self.textView isFirstResponder];
            
            [UIView animateWithDuration:0.5
                                  delay:0.0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.7
                                options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [self.view layoutIfNeeded];
                                 
                                 if (animations) {
                                     animations();
                                 }
                             }
                             completion:NULL];
            
            [self.view slk_animateLayoutIfNeededWithBounce:bounces
                                                   options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState
                                                animations:^{
                                                    if (self.isEditing) {
                                                        [self.textView slk_scrollToCaretPositonAnimated:NO];
                                                    }
                                                }];
        }
        else {
            [self.view layoutIfNeeded];
        }
#endif

        [self.view layoutIfNeeded];
    }
    
    // Only updates the input view if the number of line changed
    //[self reloadInputAccessoryViewIfNeeded];
    
    // Toggles auto-correction if requiered
    //[self enableTypingSuggestionIfNeeded];

}

@end
