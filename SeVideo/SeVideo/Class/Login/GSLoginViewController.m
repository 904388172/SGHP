//
//  GSLoginViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/9/4.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSLoginViewController.h"
#import "GSTabBarViewController.h"
#import "GSUserDefaultStatus.h"
#import "GSSQLManager.h"
#import "GSRegisterViewController.h"

#define LOGOHIGHT 25
const CGFloat kLoginCellHeight = 40;

@interface GSLoginViewController () <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UITextField *userText;
@property (strong, nonatomic) UITextField *passwordText;
@property (strong, nonatomic) UIButton *loginButton;

/** 用户名*/
@property(nonatomic, copy) NSString *userName;
/** 密码*/
@property(nonatomic, copy) NSString *passWord;

@property (nonatomic, strong) UIView *bottomView;


@end

@implementation GSLoginViewController

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登陆";
    
    [self initUI];
}

- (void) initUI {
    //图标
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_house"]];
    CGSize imageSize = self.imageView.frame.size;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.left.mas_equalTo(self.view.mas_left).offset((SCREEN_WIDTH - imageSize.width)/2);
        make.size.mas_equalTo(imageSize);
    }];
    
    //图标下方文字
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.font = [UIFont boldSystemFontOfSize:24];
    messageLabel.textColor = [GSTools returnMainUIColor];
    messageLabel.text = @"服务区信息化平台";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(DEFAULT_INTERVAL);
        make.left.right.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    //账号
    UILabel *userNameLabel = [[UILabel alloc]init];
    userNameLabel.font = [UIFont systemFontOfSize:16];
    userNameLabel.textColor = [GSTools returnTextColor];
    userNameLabel.text = @"账号：";
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(messageLabel.mas_bottom).offset(80);
        make.left.mas_equalTo(DEFAULT_INTERVAL);
        make.height.mas_equalTo(kLoginCellHeight);
    }];
    
    self.userText = [[UITextField alloc]init];
    [self.userText setFont:[UIFont systemFontOfSize:16]];
    [self.userText setTextColor:[GSTools returnTextColor]];
    self.userText.placeholder = @"请输入账号";
    [self.view addSubview:self.userText];
    [self.userText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userNameLabel.mas_right).offset(DEFAULT_INTERVAL);
        make.top.mas_equalTo(userNameLabel.mas_top);
        make.trailing.mas_equalTo(-DEFAULT_INTERVAL);
        make.height.mas_equalTo(userNameLabel.mas_height);
    }];
    
    UIView*  headLineView=[[UIView alloc] init];
    headLineView.backgroundColor=[GSTools returnSeparateColor];
    [self.view addSubview:headLineView];
    [headLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(userNameLabel.mas_leading);
        make.trailing.mas_equalTo(self.userText.mas_trailing);
        make.top.mas_equalTo(userNameLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //密码
    UILabel *userPswLabel = [[UILabel alloc]init];
    userPswLabel.font = [UIFont systemFontOfSize:16];
    userPswLabel.textColor = [GSTools returnTextColor];
    userPswLabel.text = @"密码：";
    userPswLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:userPswLabel];
    [userPswLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headLineView.mas_bottom).offset(DEFAULT_INTERVAL);
        make.left.mas_equalTo(userNameLabel.mas_left);
        make.height.mas_equalTo(kLoginCellHeight);
    }];
    
    self.passwordText = [[UITextField alloc]init];
    [self.passwordText setFont:[UIFont systemFontOfSize:16]];
    [self.passwordText setTextColor:[GSTools returnTextColor]];
    self.passwordText.clearButtonMode = UITextFieldViewModeAlways;
    self.passwordText.delegate=self;
    self.passwordText.tag = 1000;
    self.passwordText.placeholder = @"请输入密码";
    self.passwordText.secureTextEntry = YES;
    [self.view addSubview:self.passwordText];
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userPswLabel.mas_right).offset(DEFAULT_INTERVAL);
        make.top.mas_equalTo(userPswLabel.mas_top);
        make.trailing.mas_equalTo(-DEFAULT_INTERVAL);
        make.height.mas_equalTo(userPswLabel.mas_height);
    }];
    
    UIView*  footLineView=[[UIView alloc] init];
    footLineView.backgroundColor=[GSTools returnSeparateColor];
    [self.view addSubview:footLineView];
    [footLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(userPswLabel.mas_leading);
        make.trailing.mas_equalTo(self.passwordText.mas_trailing);
        make.top.mas_equalTo(userPswLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.backgroundColor = [GSTools returnMainUIColor];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(DEFAULT_INTERVAL);
        make.top.mas_equalTo(footLineView.mas_bottom).offset(kLoginCellHeight);
        make.trailing.mas_equalTo(-DEFAULT_INTERVAL);
        make.height.mas_equalTo(kLoginCellHeight);
    }];
    
    //注册按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@" 注册账号 " forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [registerButton setTitleColor:[GSTools returnTextColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-DEFAULT_INTERVAL);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(DEFAULT_INTERVAL/2);
        make.height.mas_equalTo(kLoginCellHeight);
    }];
    
    //收回键盘操作
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(DEFAULT_INTERVAL);
        make.right.mas_equalTo(self.view.mas_right).offset(-DEFAULT_INTERVAL);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
    
    [self createAppType];
}
- (void)createAppType {
    //设置默认值
    if ([[GSUserDefaultStatus sharedManager] returnMainUIColor] == nil) {
        [[GSUserDefaultStatus sharedManager] saveMainUIColor:@"0"];
        [[GSUserDefaultStatus sharedManager] saveMainServerHost:@"http://api.sg00.xyz/api/"];
        [[GSUserDefaultStatus sharedManager] saveOtherServerHost:@"http://sg01.sg01.sg01.xyz//api/"];
    }
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"🥒",@"🍓", @"🌻",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    //设置frame
    segmentedControl.frame = CGRectMake(0, 0, SCREEN_WIDTH-DEFAULT_INTERVAL*2, 40);
    segmentedControl.selectedSegmentIndex = [[[GSUserDefaultStatus sharedManager] returnMainUIColor] intValue];
   
    segmentedControl.tintColor = RGB(255,20,147);
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [self.bottomView addSubview:segmentedControl];
    
}
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender{
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:{
            [[GSUserDefaultStatus sharedManager] saveMainUIColor:@"0"];
            [[GSUserDefaultStatus sharedManager] saveMainServerHost:@"http://api.sg00.xyz/api/"];
            [[GSUserDefaultStatus sharedManager] saveOtherServerHost:@"http://sg01.sg01.sg01.xyz//api/"];
        }
            break;
            
        case 1:{
            [[GSUserDefaultStatus sharedManager] saveMainUIColor:@"1"];
            [[GSUserDefaultStatus sharedManager] saveMainServerHost:@"http://cmadmin.caomeisp666.com/api/"];
            [[GSUserDefaultStatus sharedManager] saveOtherServerHost:@"http://cmadmin.caomeisp666.com/api/"];
        }
            break;
        case 2:{
            [[GSUserDefaultStatus sharedManager] saveMainUIColor:@"2"];
            [[GSUserDefaultStatus sharedManager] saveMainServerHost:@"http://8zs71v.xrk666.com//api/"];
            [[GSUserDefaultStatus sharedManager] saveOtherServerHost:@"http://8zs71v.xrk666.com//api/"];
        }
            break;
            
        default:
            break;
    }
}
                                           

//收回键盘方法
- (void)tapClick
{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag== 1000) {
        int MAX_CHARS = 16;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        [newtxt replaceCharactersInRange:range withString:string];
        return ([newtxt length] <= MAX_CHARS );
    } else {
        return YES;
    }
}
#pragma mark ================ 登陆 ===================
-(void)login{
    [self.view endEditing:YES];

    self.userName =[self.userText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.passWord =[self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];    
    
    NSArray *arr = [[GSSQLManager shareDatabase] queryAllUserInfo];
    
    if (self.userName.length == 0) {
        [self handleMessage:@"请输入账号"];  // 账号不能为空
        return;
    }
    if (self.passWord.length == 0) {
        [self handleMessage:@"请输入密码"];   //密码不能为空
        return;
    }
    
    
    if ([self.userName isEqualToString:@"gengshuang"]) { //创造者
        //先把密码加密一次在判断是否正确
        self.passWord = [GSTools encryptStringWithString:self.passWord andKey:@"GS"];
        if ([self.passWord isEqualToString:@"37b31e7d9af7d9dbbefbd99bcea49364"]) {
            [[GSUserDefaultStatus sharedManager] saveUUID:[self getUUID]];
            //保存账号
            [[GSUserDefaultStatus sharedManager] saveUserName:self.userName];
            //保存用户权限
            [[GSUserDefaultStatus sharedManager] saveRoleStatus:@"1"];
            //保存用户信息
            [[GSUserDefaultStatus sharedManager] saveLoginInfo];
            
            //登录成功跳转首页
            GSTabBarViewController *mainVC = [[GSTabBarViewController alloc] init];
            G_CARRIR_TYPE = CARRIER_TYPE_MAIN;
            [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
        } else {
            [self handleMessage:@"账号或密码错误！"];
        }
        
    } else {
        //是否存在该账号
        if ([[GSSQLManager shareDatabase] isExistUserInfo:self.userName]) {
            NSDictionary *user = [[GSSQLManager shareDatabase] queryUserInfo:self.userName];
            //存在账号校验密码是否正确
            if ([self.passWord isEqualToString:user[@"password"]]){
                [[GSUserDefaultStatus sharedManager] saveUUID:[self getUUID]];
                
                //保存登陆的账号
                [[GSUserDefaultStatus sharedManager] saveUserName:self.userName];
                //保存用户权限
                [[GSUserDefaultStatus sharedManager] saveRoleStatus:user[@"status"]];
                //保存用户信息
                [[GSUserDefaultStatus sharedManager] saveLoginInfo];
                
                //登录成功跳转首页
                GSTabBarViewController *mainVC = [[GSTabBarViewController alloc] init];
                G_CARRIR_TYPE = CARRIER_TYPE_MAIN;
                [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
            } else {
                [self handleMessage:@"账号或密码错误！"];
            }
        } else {
//            //登录成功跳转首页
//            GSTabBarViewController *mainVC = [[GSTabBarViewController alloc] init];
//            G_CARRIR_TYPE = CARRIER_TYPE_BELARUS;
//            [[GSUserDefaultStatus sharedManager] saveUUID:[self getUUID]];
//            [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
            
            [self handleMessage:@"账号或密码错误！"];
        }
    }
}
- (NSMutableString *)getUUID {
    //获取UUID
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    NSMutableString *tmpResult = result.mutableCopy;
    // 去除“-”
    NSRange range = [tmpResult rangeOfString:@"-"];
    while (range.location != NSNotFound) {
        [tmpResult deleteCharactersInRange:range];
        range = [tmpResult rangeOfString:@"-"];
    }
    return tmpResult;
}
#pragma mark ================ 注册 ===================
- (void)registerUser:(UIButton *)sender {
    GSRegisterViewController *vc = [[GSRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//提示信息
- (void)handleMessage:(NSString *)message
{
    [HintView showInCurrentViewWithMessage:message];
}
@end
