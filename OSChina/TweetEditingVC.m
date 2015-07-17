//
//  TweetEditingVC.m
//  OSChina
//
//  Created by sky on 15/7/8.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "TweetEditingVC.h"
#import "EmojiPageVC.h"
#import "OSCAPI.h"
#import "Config.h"
#import "Utils.h"
#import "PlaceholderTextView.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>
#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <MBProgressHUD.h>
#import <ReactiveCocoa.h>

@interface TweetEditingVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (nonatomic, strong) PlaceholderTextView *edittingArea;
@property (nonatomic, strong) UIImageView             *imageView;
@property (nonatomic, strong) UIToolbar               *toolBar;
@property (nonatomic, strong) EmojiPageVC             *emojiPageVC;

@property (nonatomic, strong) UIImage                 *image;

@property (nonatomic, assign) NSLayoutConstraint      *keyboardHeight;

@end

@implementation TweetEditingVC

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"弹一弹";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"send"] style:UIBarButtonItemStylePlain target:self action:@selector(pubTweet)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubViews];
    [self setLayout];
    
    _emojiPageVC = [[EmojiPageVC alloc] initWithTextView:_edittingArea];
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [_edittingArea.rac_textSignal map:^(NSString *text) {
        return @(text.length > 0);
    }];
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

- (void)initSubViews {
    _edittingArea = [[PlaceholderTextView alloc] initWithPlaceholder:@"今天你动弹了吗？ "];
    _edittingArea.delegate = self;
    _edittingArea.placeholderFont = [UIFont systemFontOfSize:17];
    _edittingArea.returnKeyType = UIReturnKeySend;
    _edittingArea.enablesReturnKeyAutomatically = YES;
    _edittingArea.scrollEnabled = NO;
    _edittingArea.font = [UIFont systemFontOfSize:18];
    _edittingArea.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_edittingArea];
    [_edittingArea becomeFirstResponder];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [_imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressInImage)]];
    _imageView.userInteractionEnabled = YES;
    _imageView.image = _image;
    _image = nil;
    [self.view addSubview:_imageView];
    
    /**** toolBar*******/
    _toolBar = [UIToolbar new];
    
    UIBarButtonItem *flexiblseSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 25.0f;
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] initWithObjects:fixedSpace, nil];
    NSArray *iconName = @[@"toolbar-image", @"toolbar-mention", @"toolbar-reference", @"toolbar-emoji"];
    NSArray *action = @[@"addImage", @"mentionSomeone", @"referSoftware", @"switchInputView"];
    
    for (int i = 0; i < 4; i++) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:iconName[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:NSSelectorFromString(action[i])];
//        button.tintColor = [UIColor grayColor];
        [barButtonItems addObject:button];
        if (i < 3) {
            [barButtonItems addObject:flexiblseSpace];
        }
    }
    [barButtonItems addObject:fixedSpace];
    [_toolBar setItems:barButtonItems];
    
    // 底部添加border
    UIView *bottomBorder = [UIView new];
    bottomBorder.backgroundColor = [UIColor lightGrayColor];
    bottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [_toolBar addSubview:bottomBorder];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(bottomBorder);
    
    [_toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomBorder]|" options:0 metrics:nil views:views]];
    [_toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomBorder(0.5)]|" options:0 metrics:nil views:views]];
    
    [self.view addSubview:_toolBar];
}

- (void)setLayout {
    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_edittingArea,_imageView,_toolBar);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_edittingArea(>=200)]-15-[_imageView(90)]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_edittingArea]-8-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_imageView(90)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_toolBar]|" options:0 metrics:nil views:views]];
    _keyboardHeight = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_toolBar  attribute:NSLayoutAttributeBottom multiplier:1.0f constant:216];
    
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

#pragma mark - 增删照片
- (void)addImage {
    
    [[[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil] showInView:self.view];
}

#pragma mark - 插入字符串操作（@人 和 引用软件）
- (void)mentionSomeone {
    [self insertEditingString:@"@请输入用户名 "];
}

- (void)referSoftware {
    [self insertEditingString:@"#请输入软件名#"];
}

#pragma mark - 表情面板和键盘切换
- (void)switchInputView {
    //还要考虑一下用外接键盘输入时，置空inputview后 字体小得情况
    if (_edittingArea.inputView == self.emojiPageVC.view) {
        [_toolBar.items[7] setImage:[[UIImage imageNamed:@"toolbar-emoji"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _edittingArea.inputView = nil;
        _edittingArea.font = [UIFont systemFontOfSize:18];
        [_edittingArea reloadInputViews];
    } else {
        _keyboardHeight.constant = 216;
        [self.view layoutIfNeeded];
        
        [_toolBar.items[7] setImage:[[UIImage imageNamed:@"toolbar-text"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _edittingArea.inputView = self.emojiPageVC.view;
        [_edittingArea reloadInputViews];
    }
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

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    } else if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = NO;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Devices has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = NO;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _imageView.image = info[UIImagePickerControllerOriginalImage];
    
    //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
    //UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - handle long press gesture
- (void)handleLongPressInImage {
    _imageView.image = nil;
}

#pragma mark - 发表动弹
- (void)pubTweet {
    MBProgressHUD *hub = [Utils createHUDInWindowOfView:self.view];
    hub.labelText = @"动弹发送中";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_TWEET_PUB] parameters:@{@"uid": @([Config getOwnID]), @"msg": [Utils convertRichTextToRawText:_edittingArea]} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (_imageView.image) {
            [formData appendPartWithFileData:[Utils compressImage:_imageView.image] name:@"img" fileName:@"img.jpg" mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
        ONOXMLElement *result = [responseDocument.rootElement firstChildWithTag:@"result"];
        int errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] intValue];
        NSString *errorMessage = [[result firstChildWithTag:@"errorMessage"] stringValue];
        
        hub.mode = MBProgressHUDModeCustomView;
        
        if (errorCode == 1) {
            _edittingArea.text = @"";
            _imageView.image = nil;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = @"动弹发表成功";
            
            [self dismissViewControllerAnimated:YES completion:nil];
           
        } else {
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
        }
        
        [hub hide:YES afterDelay:2];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hub.mode = MBProgressHUDModeCustomView;
        hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        hub.labelText = @"网络异常，动弹发送失败";
        
        [hub hide:YES afterDelay:2];
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self pubTweet];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(PlaceholderTextView *)textView {
    [textView checkShouldHidePlaceholder];
    self.navigationItem.rightBarButtonItem.enabled = [textView hasText];
}

- (void)textViewDidChange:(PlaceholderTextView *)textView {
    [textView checkShouldHidePlaceholder];
    self.navigationItem.rightBarButtonItem.enabled = [textView hasText];
}

@end
