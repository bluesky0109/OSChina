//
//  TweetEditingVC.m
//  OSChina
//
//  Created by sky on 15/7/8.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TweetEditingVC.h"
#import "EmojiPageVC.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface TweetEditingVC ()

@property (nonatomic, strong) UITextView         *edittingArea;
@property (nonatomic, strong) UIImageView        *imageView;
@property (nonatomic, strong) UIToolbar          *toolBar;
@property (nonatomic, assign) NSLayoutConstraint *keyboardHeight;

@end

@implementation TweetEditingVC

- (void)loadView {
    [super loadView];
    
    [self initSubviews];
    [self setLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"弹一弹";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initSubviews {
    _edittingArea = [UITextView new];
    _edittingArea.scrollEnabled = NO;
    _edittingArea.font = [UIFont systemFontOfSize:18];
    _edittingArea.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_edittingArea];
    
    _imageView = [UIImageView new];
    
    _toolBar = [UIToolbar new];
    
    UIBarButtonItem *flexiblseSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 25.0f;
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] initWithObjects:fixedSpace, nil];
    NSArray *iconName = @[@"compose_toolbar_picture_normal", @"compose_toolbar_mention_normal", @"compose_toolbar_trend_normal", @"compose_toolbar_emoji_normal"];
    NSArray *action = @[@"addImage", @"mentionSomeone", @"referSoftware", @"selectEmoji"];
    
    for (int i = 0; i < 4; i++) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:iconName[i]] style:UIBarButtonItemStylePlain target:self action:NSSelectorFromString(action[i])];
        button.tintColor = [UIColor grayColor];
        [barButtonItems addObject:button];
        if (i < 3) {
            [barButtonItems addObject:flexiblseSpace];
        }
    }
    [barButtonItems addObject:fixedSpace];
    [_toolBar setItems:barButtonItems];
    
    [self.view addSubview:_toolBar];
}

- (void)setLayout {
    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_edittingArea,_imageView,_toolBar);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_edittingArea]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_edittingArea]-8-|" options:0 metrics:nil views:views]];
    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_toolBar]|" options:0 metrics:nil views:views]];
    _keyboardHeight = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_toolBar  attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    
    [self.view addConstraint:_keyboardHeight];
}

- (void)cancelButtonClicked {
    [_edittingArea resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight.constant = keyboardBounds.size.height;
    [self.view setNeedsUpdateConstraints];
    
    NSTimeInterval animationDuration;
    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardHeight.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    NSTimeInterval animationDuration;
    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - TollBar操作
- (void)addImage {
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = YES;
    imagePickerController.showsCameraControls = YES;
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)mentionSomeone {
    [self insertEditingString:@"@请输入用户名 "];
}

- (void)referSoftware {
    [self insertEditingString:@"#请输入软件名#"];
}

- (void)selectEmoji {
    EmojiPageVC *emojiPageVC = [[EmojiPageVC alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:nil];
    [self addChildViewController:emojiPageVC];
    [self.view addSubview:emojiPageVC.view];
    
    NSDictionary *views = @{@"emojiView": emojiPageVC.view};
    emojiPageVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emojiView(216)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[emojiView]|" options:0 metrics:nil views:views]];
    
    _keyboardHeight.constant = 216;
    [self.view layoutIfNeeded];
}

- (void)insertEditingString:(NSString *)string {
    [_edittingArea becomeFirstResponder];
    
    NSUInteger cursorLocation = _edittingArea.selectedRange.location;
    [_edittingArea replaceRange:_edittingArea.selectedTextRange withText:string];
    
    
    UITextPosition *selectedStartPos = [_edittingArea positionFromPosition:_edittingArea.beginningOfDocument offset:cursorLocation + 1];
    UITextPosition *selectedEndPos = [_edittingArea positionFromPosition:_edittingArea.beginningOfDocument offset:cursorLocation + string.length - 1];
    UITextRange *newRange = [_edittingArea textRangeFromPosition:selectedStartPos toPosition:selectedEndPos];
    
    [_edittingArea setSelectedTextRange:newRange];
}

@end
