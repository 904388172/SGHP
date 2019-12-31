//
//  GSUserDefaultStatus.h
//  SeVideo
//
//  Created by 耿双 on 2019/9/4.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSUserDefaultStatus : NSObject

+ (GSUserDefaultStatus *)sharedManager;
//是否登录
+ (BOOL)isLogin;

//保存登陆用户账号
- (void)saveUserName:(NSString *)userName;
//获取用户的登录账户
- (NSString*)returnUserName;

//保存账号权限
- (void)saveRoleStatus:(NSString *)status;
//获取账户权限
- (NSString*)returnRoleStatus;

//保存用户信息
- (void)saveLoginInfo;
//删除用户信息
- (void)clearUserInfo;

//保存UUID
- (void)saveUUID:(NSString *)uuid;
//获取UUID
- (NSString*)returnUUID;


//保存UI颜色
- (void)saveMainUIColor:(NSString *)color;
//获取UI颜色
- (NSString*)returnMainUIColor;

//保存主要API地址
- (void)saveMainServerHost:(NSString *)host;
//获取UUID
- (NSString*)returnMainServerHost;
//保存次要API地址
- (void)saveOtherServerHost:(NSString *)host;
//获取UUID
- (NSString*)returnOtherServerHost;


@end

NS_ASSUME_NONNULL_END
