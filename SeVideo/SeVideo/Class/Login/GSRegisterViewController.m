//
//  GSRegisterViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/9/6.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSRegisterViewController.h"
#import "GSTextFieldView.h"
//#import "GSUserDefaultStatus.h"
#import "GSSQLManager.h"

@interface GSRegisterViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *iconButtom;
@property (nonatomic, strong) GSTextFieldView *accountView;
@property (nonatomic, strong) GSTextFieldView *passwordView;
@property (nonatomic, strong) GSTextFieldView *surePswView;
@property (nonatomic, strong) GSTextFieldView *phoneView;
@property (nonatomic, copy) NSString *imageString;

@end

@implementation GSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.imageString = @"";
    
    self.iconButtom = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconButtom.layer.cornerRadius = 50.0;
    self.iconButtom.backgroundColor = [GSTools returnMainUIColor];
    [self.iconButtom addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.iconButtom];
    [self.iconButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64 + DEFAULT_INTERVAL);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    self.accountView = [[GSTextFieldView alloc] init];
    self.accountView.textName = @"账号";
    [self.view addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconButtom.mas_bottom).offset(DEFAULT_INTERVAL);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.passwordView = [[GSTextFieldView alloc] init];
    self.passwordView.textName = @"密码";
    [self.view addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.surePswView = [[GSTextFieldView alloc] init];
    self.surePswView.textName = @"确认密码";
    [self.view addSubview:self.surePswView];
    [self.surePswView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.phoneView = [[GSTextFieldView alloc] init];
    self.phoneView.textName = @"手机号码";
    [self.view addSubview:self.phoneView];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.surePswView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textColor = [GSTools returnDetailColor];
    tipLabel.text = @"提示:手机号码可以用来修改账号密码！";
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneView.mas_bottom).offset(DEFAULT_INTERVAL);
        make.left.mas_equalTo(self.view.mas_left).offset(DEFAULT_INTERVAL);
        make.right.mas_equalTo(self.view.mas_right).offset(-DEFAULT_INTERVAL);
    }];
    
    //注册按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@" 注册账号 " forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.layer.cornerRadius = 5;
    registerButton.backgroundColor = [GSTools returnMainUIColor];
    [registerButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(DEFAULT_INTERVAL);
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(50);
        make.trailing.mas_equalTo(-DEFAULT_INTERVAL);
        make.height.mas_equalTo(50);
    }];
    //收回键盘操作
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

//收回键盘方法
- (void)tapClick
{
    [self.view endEditing:YES];
}

- (void)addImage:(UIButton *)sender {
    //初始化UIImagePickerController类
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    //判断数据来源为相册
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //设置代理
    picker.delegate = self;
    //打开相册
    [self presentViewController:picker animated:YES completion:nil];
}
//选择完成回调函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    image = [self scaleToSize:image size:CGSizeMake(100, 100)];
    [self.iconButtom setImage:image forState:UIControlStateNormal];
    
    //UIImage图片转Base64字符串：
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    self.imageString = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

}
#pragma mark ================ 压缩图片 ===================
/// 压缩图片大小 并不是截取图片而是按照size绘制图片
- (UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size {
    // 创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 保存图片
    // UIImageWriteToSavedPhotosAlbum(scaledImage, nil, nil, nil);
    return scaledImage;
}
//用户取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ================ 注册 ===================
- (void)registerUser:(UIButton *)sender {
    
    if ([self.accountView.texeField.text isEqualToString:@""]) {
        [HintView showInCurrentViewWithMessage:@"请输入账号"];
        return;
    }
    if ([self.passwordView.texeField.text isEqualToString:@""]) {
        [HintView showInCurrentViewWithMessage:@"请输入密码"];
        return;
    } else {
        if (![self.passwordView.texeField.text isEqualToString:self.surePswView.texeField.text]) {
            [HintView showInCurrentViewWithMessage:@"两次密码不一致"];
            return;
        }
    }
    if ([self.phoneView.texeField.text isEqualToString:@""]) {
        [HintView showInCurrentViewWithMessage:@"请输入手机号码"];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.accountView.texeField.text forKey:@"username"];
    [dic setValue:self.passwordView.texeField.text forKey:@"password"];
    // 1:超级管理员，2:VIP用户，3:普通用户，默认都是普通用户
    if ([self.accountView.texeField.text isEqualToString:@"gengshuang"] && [self.passwordView.texeField.text isEqualToString:@"admin"]) {
        [dic setValue:@"1" forKey:@"status"];
    } else {
        [dic setValue:@"3" forKey:@"status"];
    }
    
    [dic setValue:self.phoneView.texeField.text forKey:@"phone"];
    [dic setValue:self.imageString forKey:@"image"];
    
    BOOL isSuccess = [[GSSQLManager shareDatabase] insertUserInfo:dic];
    if (isSuccess) {
        [HintView showInCurrentViewWithMessage:@"注册账号成功"];
    } else {
        [HintView showInCurrentViewWithMessage:@"注册账号失败"];
    }
    
    NSArray *arr = [[GSSQLManager shareDatabase] queryAllUserInfo];
    
    NSLog(@"ssss");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
