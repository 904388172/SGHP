//
//  GSSettingViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/9/5.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSSettingViewController.h"
#import "GSUserDefaultStatus.h"
#import "GSSQLManager.h"
#import "GSLoginViewController.h"
#import "GSBaseNavViewController.h"
#import "GSExchangeRoleViewController.h"
#import "GSSQLManager.h"

@interface GSSettingViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImageView *headImgView;
}
@property (nonatomic, strong) UIButton *outButton;

@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation GSSettingViewController

- (NSDictionary *)userInfo {
    if (!_userInfo) {
        _userInfo = [[NSDictionary alloc] init];
    }
    return _userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    //获取当前用户的信息
    NSString *userName = [[GSUserDefaultStatus sharedManager] returnUserName];
    self.userInfo = [[GSSQLManager shareDatabase] queryUserInfo:userName];
    
    [self addInfoView];
    
    //超级管理员有修改权限按钮
    if ([self.userInfo[@"status"] isEqualToString:@"1"]) {
        //修改权限
        UIButton *exchangeRole = [UIButton buttonWithType:UIButtonTypeCustom];
        [exchangeRole setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
        exchangeRole.frame = CGRectMake(0, 0, 44, 44);
        [exchangeRole addTarget:self action:@selector(exchangeRole:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:exchangeRole];
    }
}
#pragma mark ================ 修改权限 ===================
- (void)exchangeRole:(UIButton *)sender {
    GSExchangeRoleViewController *vc = [[GSExchangeRoleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)exchangeImage:(UILongPressGestureRecognizer *)longGap {
    // 一般开发中,长按操作只会做一次
    // 假设在一开始长按的时候就做一次操作
    
    if (longGap.state == UIGestureRecognizerStateBegan) {
        
        //初始化UIImagePickerController类
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //判断数据来源为相册
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //设置代理
        picker.delegate = self;
        //打开相册
        [self presentViewController:picker animated:YES completion:nil];
    }
}
//选择完成回调函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    image = [self scaleToSize:image size:CGSizeMake(100, 100)];
    headImgView.image = image;
    
    //UIImage图片转Base64字符串：
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    
    [[GSSQLManager shareDatabase] updateUserInfo:self.userInfo[@"username"] withKey:@"image" withValue:[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    
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

- (void)addInfoView {
    //图像
    headImgView = [[UIImageView alloc] init];
    //Base64字符串转UIImage图片：
    if (self.userInfo[@"image"] != nil) {
        NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:self.userInfo[@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
        headImgView.image = decodedImage;
    } else {
        headImgView.image = [UIImage imageNamed:@"dahuan"];
    }
    headImgView.userInteractionEnabled = YES;
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = 50.0;
    [self.view addSubview:headImgView];
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(DEFAULT_INTERVAL);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    // 长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeImage:)];
    [headImgView addGestureRecognizer:longPress];
    
    //账号
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [GSTools returnTextColor];
    nameLabel.text = [NSString stringWithFormat:@"%@%@",@"当前账号：",self.userInfo[@"username"]];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImgView.mas_bottom).offset(DEFAULT_INTERVAL);
        make.left.mas_equalTo(self.view.mas_left).offset(DEFAULT_INTERVAL);
        make.right.mas_equalTo(self.view.mas_right).offset(-DEFAULT_INTERVAL);
        make.height.mas_equalTo(50);
    }];
    
    UIView *line1=[[UIView alloc] init];
    line1.backgroundColor=[GSTools returnSeparateColor];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(nameLabel.mas_leading);
        make.trailing.mas_equalTo(nameLabel.mas_trailing);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //手机号码
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.textColor = [GSTools returnTextColor];
    phoneLabel.text = [NSString stringWithFormat:@"%@%@",@"手机号码：",self.userInfo[@"phone"]];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(nameLabel.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    UIView *line2=[[UIView alloc] init];
    line2.backgroundColor=[GSTools returnSeparateColor];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(nameLabel.mas_leading);
        make.trailing.mas_equalTo(nameLabel.mas_trailing);
        make.top.mas_equalTo(phoneLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //用户权限
    UILabel *roleLabel = [[UILabel alloc]init];
    roleLabel.font = [UIFont systemFontOfSize:16];
    roleLabel.textColor = [GSTools returnTextColor];
    if ([self.userInfo[@"status"] isEqualToString:@"1"]) {
        roleLabel.text = [NSString stringWithFormat:@"%@%@",@"用户权限：",@"超级管理员"];
    } else if ([self.userInfo[@"status"] isEqualToString:@"2"]) {
        roleLabel.text = [NSString stringWithFormat:@"%@%@",@"用户权限：",@"VIP"];
    } else {
        roleLabel.text = [NSString stringWithFormat:@"%@%@",@"用户权限：",@"普通用户"];
    }
    
    roleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:roleLabel];
    [roleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom);
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(nameLabel.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    
    UIView *line3=[[UIView alloc] init];
    line3.backgroundColor=[GSTools returnSeparateColor];
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(nameLabel.mas_leading);
        make.trailing.mas_equalTo(nameLabel.mas_trailing);
        make.top.mas_equalTo(roleLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //登录按钮
    self.outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.outButton setTitle:@"退出" forState:UIControlStateNormal];
    self.outButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.outButton.layer.cornerRadius = 5;
    self.outButton.backgroundColor = [GSTools returnMainUIColor];
    [self.outButton addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.outButton];
    [self.outButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(nameLabel.mas_leading);
        make.top.mas_equalTo(line3.mas_bottom).offset(50);
        make.trailing.mas_equalTo(nameLabel.mas_trailing);
        make.height.mas_equalTo(50);
    }];
}

- (void)loginOut:(UIButton *)sender {
    //清除数据
    [[GSUserDefaultStatus sharedManager] clearUserInfo];
    GSLoginViewController *loginVc = [[GSLoginViewController alloc] init];
    GSBaseNavViewController *nav = [[GSBaseNavViewController alloc] initWithRootViewController:loginVc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

@end
