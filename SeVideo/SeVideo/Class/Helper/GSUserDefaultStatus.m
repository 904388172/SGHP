//
//  GSUserDefaultStatus.m
//  SeVideo
//
//  Created by 耿双 on 2019/9/4.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSUserDefaultStatus.h"

@implementation GSUserDefaultStatus

+(GSUserDefaultStatus *)sharedManager {
    static GSUserDefaultStatus *userDefaultStatus = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefaultStatus = [[GSUserDefaultStatus alloc] init];
    });
    return userDefaultStatus;
}

//保存登陆用户账号
- (void)saveUserName:(NSString *)userName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:@"userName"];
    [userDefaults synchronize];
}
//获取用户的登录账户
- (NSString*)returnUserName {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes objectForKey:@"userName"];
}

//保存账号权限
- (void)saveRoleStatus:(NSString *)status {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:status forKey:@"status"];
    [userDefaults synchronize];
}
//获取账户权限
- (NSString*)returnRoleStatus {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes objectForKey:@"status"];
}

//保存用户登录信息
- (void)saveLoginInfo {

    NSString *loginStr = @"Login";
    [[NSUserDefaults standardUserDefaults] setObject:loginStr forKey:@"Login"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//删除用户信息
- (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Login"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"status"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UUID"];
}
//是否登录
+ (BOOL)isLogin {
    NSString *loginStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"];
    if (loginStr == NULL) {
        return NO;
    }
    return YES;
}

//保存UUID
- (void)saveUUID:(NSString *)uuid {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:uuid forKey:@"UUID"];
    [userDefaults synchronize];
}
//获取UUID
- (NSString*)returnUUID {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes objectForKey:@"UUID"];
}


//保存主要API地址
- (void)saveMainServerHost:(NSString *)host {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:host forKey:@"MainServerHost"];
    [userDefaults synchronize];
}
//获取UUID
- (NSString*)returnMainServerHost {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes objectForKey:@"MainServerHost"];
}
//保存次要API地址
- (void)saveOtherServerHost:(NSString *)host {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:host forKey:@"OtherServerHost"];
    [userDefaults synchronize];
}
//获取UUID
- (NSString*)returnOtherServerHost {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes objectForKey:@"OtherServerHost"];
}

//保存UI颜色
- (void)saveMainUIColor:(NSString *)color {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:color forKey:@"MAINUIColor"];
    [userDefaults synchronize];
}
//获取UI颜色
- (NSString*)returnMainUIColor {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes objectForKey:@"MAINUIColor"];
}

@end
