//
//  GSSQLManager.h
//  SeVideo
//
//  Created by 耿双 on 2019/9/5.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import <FMDatabaseQueue.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSSQLManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *queue;
@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)shareDatabase;

/**
 * 往数据库插入数据
 *
 * @param dic 用户信息
 * @param BOOL
 */
- (BOOL)insertUserInfo:(NSDictionary *)dic;

/**
 * 获取所有的数据
 *
 * @param NSMutableArray
 */
- (NSMutableArray *)queryAllUserInfo;

/**
 * 获取某一条数据
 *
 * @param NSDictionary
 */
- (NSDictionary *)queryUserInfo:(NSString *)userName;

/**
 * 删除数据库中的某一条数据
 *
 * @param userName 用户名
 * @param BOOL
 */
- (BOOL)deleteUserInfo:(NSString *)userName;

/**
 * 修改数据库中的某一条数据
 *
 * @param userName 用户名
 * @param key 修改的字段名称
 * @param value 修改的值
 * @param BOOL
 */
- (BOOL)updateUserInfo:(NSString *)userName withKey:(NSString *)type withValue:(NSString *)variable;

/**
 * 判断是否存在某一个数据
 *
 * @param userName 用户名
 * @param BOOL
 */
- (BOOL)isExistUserInfo:(NSString *)userName;

/**
 * 删除数据库
 *
 * @param BOOL
 */
- (BOOL)removeUserInfo;

@end

NS_ASSUME_NONNULL_END
