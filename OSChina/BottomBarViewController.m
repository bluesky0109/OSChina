//
//  BottomBarViewController.m
//  OSChina
//
//  Created by sky on 15/7/2.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "BottomBarViewController.h"
#import "GrowingTextView.h"
#import "EmojiPageVC.h"

@interface BottomBarViewController ()<UITextViewDelegate>

@property (nonatomic, strong) EmojiPageVC *emojiPageVC;
@property (nonatomic, assign) BOOL hasAModeSwitchButton;

@end

@implementation BottomBarViewController

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton {
    self = [super init];
    if (self) {
        _editingBar = [[EditingBar alloc] initWithModeSwitchButton:hasAModeSwitchButton];
        _editingBar.editView.delegate = self;
        if (hasAModeSwitchButton) {
            _hasAModeSwitchButton = hasAModeSwitchButton;
            _operationBar = [OperationBar new];
            _operationBar.hidden = YES;
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    [self addBottomBar];
    _emojiPageVC = [[EmojiPageVC alloc] initWithTextView:_editingBar.editView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidUpdate:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)addBottomBar {

    _editingBar.translatesAutoresizingMaskIntoConstraints = NO;
    [_editingBar.inputViewButton addTarget:self action:@selector(switchInputView) forControlEvents:UIControlEventTouchUpInside];
    [_editingBar.modeSwitchButton addTarget:self action:@selector(switchMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editingBar];
    
    _editingBarYContraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_editingBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    _editingBarHeightContraint = [NSLayoutConstraint constraintWithItem:_editingBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[self minimumInputbarHeight]];
    
    [self.view addConstraint:_editingBarYContraint];
    [self.view addConstraint:_editingBarHeightContraint];
    
    if (_hasAModeSwitchButton) {
        [_operationBar.modeSwitchButton addTarget:self action:@selector(switchMode) forControlEvents:UIControlEventTouchUpInside];
        __weak BottomBarViewController *weakSelf = self;
        _operationBar.switchMode = ^ {[weakSelf switchMode];};
        
        _operationBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_operationBar];
        NSDictionary *metrics = @{@"height": @([self minimumInputbarHeight])};
        NSDictionary *views = NSDictionaryOfVariableBindings(_operationBar);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_operationBar(height)]|" options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_operationBar]|" options:0 metrics:nil views:views]];
    }
}

- (void)switchInputView {
    if (_editingBar.editView.inputView == self.emojiPageVC.view) {
        [_editingBar.editView becomeFirstResponder];
        
        [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
        _editingBar.editView.inputView = nil;
        _editingBar.editView.font = [UIFont systemFontOfSize:18];
        [_editingBar.editView reloadInputViews];
    } else {
        [_editingBar.editView becomeFirstResponder];
        
        [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"toolbar-text"] forState:UIControlStateNormal];
        _editingBar.editView.inputView = _emojiPageVC.view;
        [_editingBar.editView reloadInputViews];
        
        [self setEditingBarHeight:216];
    }
}

- (void)switchMode {
    if (_operationBar.isHidden) {
        [_editingBar.editView resignFirstResponder];
        _editingBar.hidden = YES;
        _operationBar.hidden = NO;
    } else {
        _operationBar.hidden = YES;
        _editingBar.hidden = NO;
    }
}


#pragma mark - textView配置
- (GrowingTextView *)textView {
    return self.editingBar.editView;
}

- (CGFloat)minimumInputbarHeight {
    return self.editingBar.intrinsicContentSize.height;
}

- (CGFloat)deltaInputbarHeight {
    return self.editingBar.intrinsicContentSize.height - self.textView.font.lineHeight;
}

- (CGFloat)barHeightForLines:(NSUInteger)numberOfLines {
    CGFloat height = [self deltaInputbarHeight];
    
    height += roundf(self.textView.font.lineHeight * numberOfLines);

    return height;
}

#pragma mark - 编辑框相关
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

#pragma mark - 跳转bar的高度
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self setEditingBarHeight:keyboardBounds.size.height];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self setEditingBarHeight:0];
}

- (void)setEditingBarHeight:(CGFloat)height {
    _editingBarYContraint.constant = height;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)textDidUpdate:(NSNotification *)notification {
    CGFloat inputbarHeight = [self appropriateInputbarHeight];
    
    if (inputbarHeight != self.editingBarHeightContraint.constant) {
        self.editingBarHeightContraint.constant = inputbarHeight;

        [self.view layoutIfNeeded];
    }
}

#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendContent];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(PlaceholderTextView *)textView {
    [textView checkShouldHidePlaceholder];
    self.editingBar.sendButton.enabled = [textView hasText];
}

- (void)textViewDidChange:(PlaceholderTextView *)textView {
    [textView checkShouldHidePlaceholder];
    self.editingBar.sendButton.enabled = [textView hasText];
}

- (void)sendContent {
    NSAssert(false, @"Over ride in subclasses");
}

@end
