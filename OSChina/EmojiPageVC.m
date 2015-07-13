//
//  EmojiPageVC.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "EmojiPageVC.h"
#import "EmojiPanelVC.h"

@interface EmojiPageVC ()<UIPageViewControllerDataSource>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) void (^didSelectEmoji)(NSTextAttachment *textAttachment);
@property (nonatomic, copy) void (^deleteEmoji)();

@end

@implementation EmojiPageVC

- (instancetype)initWithTextView:(UITextView *)textView {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    if (self) {
        _textView = textView;
        __weak UITextView *weakTextView = _textView;
        _didSelectEmoji = ^(NSTextAttachment *textAttachment) {
            NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:weakTextView.attributedText];
            [mutableAttributedString replaceCharactersInRange:weakTextView.selectedRange withAttributedString:emojiAttributedString];
            weakTextView.attributedText = [mutableAttributedString copy];
        };
        
        _deleteEmoji = ^ {
            NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:weakTextView.attributedText];
            NSRange range = weakTextView.selectedRange;
            if (range.length == 0 && range.location != 0) {
                [mutableAttributeString deleteCharactersInRange:NSMakeRange(range.location - 1, 1)];
            } else {
                [mutableAttributeString deleteCharactersInRange:weakTextView.selectedRange];
            }
            weakTextView.attributedText = [mutableAttributeString copy];
        };
    }
        
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    EmojiPanelVC *emojiPanelVC = [[EmojiPanelVC alloc] initWithPageIndex:0];
    emojiPanelVC.didSelectEmoji = _didSelectEmoji;
    emojiPanelVC.deleteEmoji = _deleteEmoji;
    
    if (emojiPanelVC != nil) {
        self.dataSource = self;
        [self setViewControllers:@[emojiPanelVC]
                       direction:UIPageViewControllerNavigationDirectionReverse
                        animated:NO
                      completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(EmojiPanelVC *)vc
{
    int index = vc.pageIndex;
    
    if (index == 0) {
        return nil;
    } else {
        EmojiPanelVC *emojiPanelVC = [[EmojiPanelVC alloc] initWithPageIndex:index - 1];
        emojiPanelVC.didSelectEmoji = _didSelectEmoji;
        emojiPanelVC.deleteEmoji = _deleteEmoji;

        return emojiPanelVC;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(EmojiPanelVC *)vc
{
    int index = vc.pageIndex;
    
    if (index == 5) {
        return nil;
    } else {
        EmojiPanelVC *emojiPanelVC = [[EmojiPanelVC alloc] initWithPageIndex:index + 1];
        emojiPanelVC.didSelectEmoji = _didSelectEmoji;
        emojiPanelVC.deleteEmoji = _deleteEmoji;

        return emojiPanelVC;
    }

}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 6;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}




@end
