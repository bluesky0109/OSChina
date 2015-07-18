//
//  ActivitySignUpViewController.m
//  OSChina
//
//  Created by sky on 15/7/15.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "ActivitySignUpViewController.h"
#import "UIView+Util.h"
#import "UIColor+Util.h"
#import "Config.h"
#import "OSCAPI.h"
#import "Utils.h"

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <MBProgressHUD.h>
#import <ReactiveCocoa.h>

@interface ActivitySignUpViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField        *nameTextField;
@property (nonatomic, strong) UITextField        *phoneNumberTextField;
@property (nonatomic, strong) UITextField        *corporationTextField;
@property (nonatomic, strong) UITextField        *positionTextField;
@property (nonatomic, strong) UISegmentedControl *sexSegmentCtl;
@property (nonatomic, strong) UIButton           *saveButton;

@end

@implementation ActivitySignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"活动报名";
    
    [self setLayout];
    
    NSArray *activitySignUpInfo = [Config getActivitySignUpInfomation];
    if (activitySignUpInfo.count != 0) {
        _nameTextField.text = activitySignUpInfo[0];
        _sexSegmentCtl.selectedSegmentIndex = [activitySignUpInfo[1] intValue];
        _phoneNumberTextField.text = activitySignUpInfo[2];
        _corporationTextField.text = activitySignUpInfo? activitySignUpInfo[3]: @"";
        _positionTextField.text = activitySignUpInfo? activitySignUpInfo[4]: @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout {
    UILabel *sexLabel = [UILabel new];
    sexLabel.text = @"性       别：";
    [self.view addSubview:sexLabel];
    
    _sexSegmentCtl = [[UISegmentedControl alloc] initWithItems:@[@"男", @"女"]];
    _sexSegmentCtl.selectedSegmentIndex = 0;
    _sexSegmentCtl.tintColor = [UIColor colorWithHex:0x15A230];
    [self.view addSubview:_sexSegmentCtl];
    
    _nameTextField = [UITextField new];
    _nameTextField.placeholder = @" 请输入姓名（必填）";
    //_nameTextField.delegate = self;
    _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    //_nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_nameTextField];
    
    _phoneNumberTextField = [UITextField new];
    _phoneNumberTextField.placeholder = @"请输入电话号码（必填）";
    //_phoneNumberTextField.delegate = self;
    _phoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    //_phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_phoneNumberTextField];
    
    _corporationTextField = [UITextField new];
    _corporationTextField.placeholder = @"请输入单位名称";
    _corporationTextField.delegate = self;
    _corporationTextField.borderStyle = UITextBorderStyleRoundedRect;
    _corporationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_corporationTextField];
    
    _positionTextField = [UITextField new];
    _positionTextField.placeholder = @"请输入职位名称";
    _positionTextField.delegate = self;
    _positionTextField.borderStyle = UITextBorderStyleRoundedRect;
    _positionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_positionTextField];
    
    _saveButton = [UIButton new];
    _saveButton.backgroundColor = [UIColor redColor];
    [_saveButton setCornerRadius:5.0];
    [_saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:_saveButton];
    _saveButton.userInteractionEnabled = YES;
    [_saveButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterActivity)]];
    
    RACSignal *valid = [RACSignal combineLatest:@[_nameTextField.rac_textSignal, _phoneNumberTextField.rac_textSignal]
                                         reduce:^(NSString *name, NSString *phoneNumber){
                                             return @(name.length > 0 && phoneNumber.length > 0);
                                         }];
    RAC(_saveButton, enabled) = valid;
    RAC(_saveButton, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1 : @0.4;
    }];
    
    for (UIView *subView in [self.view subviews]) {
        subView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_nameTextField, sexLabel, _sexSegmentCtl, _phoneNumberTextField, _corporationTextField, _positionTextField, _saveButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[_nameTextField(fieldHeight)]-12-[sexLabel]-15-[_phoneNumberTextField(fieldHeight)]-15-[_corporationTextField(fieldHeight)]-15-[_positionTextField(fieldHeight)]-25-[_saveButton]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:@{@"fieldHeight": @(30)} views:viewDic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_nameTextField]-10-|" options:0 metrics:nil views:viewDic]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sexLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                             toItem:_sexSegmentCtl attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sexLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                             toItem:_sexSegmentCtl attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_sexSegmentCtl(100)]" options:0 metrics:nil views:viewDic]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.view.frame.size.height < 568) {
        float y = self.view.frame.origin.y;
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        
        if (textField == _corporationTextField || textField == _positionTextField) {
            CGRect rect = CGRectMake(0.0f, y-100, width, height);
            self.view.frame = rect;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (self.view.frame.size.height < 568) {
        float y = self.view.frame.origin.y;
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        
        if (textField == _corporationTextField || textField == _positionTextField){
            CGRect rect = CGRectMake(0.0f, y+100, width, height);
            self.view.frame = rect;
        }
    }
    
    return YES;
}

//提交报名信息
- (void)enterActivity {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_EVENT_APPLY]
       parameters:@{
                    @"event":@(_eventId),
                    @"user": @([Config getOwnID]),
                    @"name":_nameTextField.text,
                    @"gender":@(_sexSegmentCtl.selectedSegmentIndex) ,
                    @"mobile":_phoneNumberTextField.text,
                    @"company":_corporationTextField.text,
                    @"job":_positionTextField.text
                    }
          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
              ONOXMLElement *result = [responseObject.rootElement firstChildWithTag:@"result"];
              
              NSInteger errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] integerValue];
              NSString *errorMessage = [[result firstChildWithTag:@"errormessage"] stringValue];
              
              MBProgressHUD *HUD = [Utils createHUDInWindowOfView:self.view];
              HUD.mode = MBProgressHUDModeCustomView;
              
              if (errorCode == 1) {
                  HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                  HUD.labelText = [NSString stringWithFormat:@"%@", errorMessage];
              } else {
                  HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                  HUD.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
              }
              
              [HUD hide:YES afterDelay:0.5];
              
              [Config saveName:_nameTextField.text sex:_sexSegmentCtl.selectedSegmentIndex phoneNumber:_phoneNumberTextField.text corporation:_corporationTextField.text andPosition:_positionTextField.text];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"网络异常，错误码：%ld", (long)error.code);
          }
     ];
    
}


@end
