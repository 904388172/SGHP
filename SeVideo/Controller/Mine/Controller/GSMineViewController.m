//
//  GSMineViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/30.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSMineViewController.h"
#import "GSBaseNavViewController.h"
#import "GSLoginViewController.h"

@interface GSMineViewController ()

@end

@implementation GSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitle:@"退出" forState:UIControlStateNormal];
    loginOut.backgroundColor = RGB(255, 105, 180);
    loginOut.layer.cornerRadius = 6;
    loginOut.layer.borderWidth = 1;
    loginOut.layer.borderColor = RGB(255, 105, 180).CGColor;
    [loginOut addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOut];
    [loginOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(DEFAULT_INTERVAL/2);
        make.top.mas_equalTo(self.view.mas_top).offset(3);
        make.width.mas_equalTo(SCREEN_WIDTH-DEFAULT_INTERVAL);
        make.height.mas_equalTo(48);
    }];
}
- (void)loginOut {
    //清除数据
    [[GSUserDefaultStatus sharedManager] clearUserInfo];
    GSLoginViewController *loginVc = [[GSLoginViewController alloc] init];
    GSBaseNavViewController *nav = [[GSBaseNavViewController alloc] initWithRootViewController:loginVc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}


@end
