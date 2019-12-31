//
//  GSSQLManager.m
//  SeVideo
//
//  Created by 耿双 on 2019/9/5.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSSQLManager.h"

@implementation GSSQLManager

+ (instancetype)shareDatabase {
    static GSSQLManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GSSQLManager alloc] init];
        [instance createQueue];
    });
    return  instance;
}
#pragma mark ================ 创建路径 ===================
- (void)createQueue {
    NSString *queuePatn = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GSSQLFMDB.db"];
    _queue = [FMDatabaseQueue databaseQueueWithPath:queuePatn];
    if (_queue) {
        NSLog(@"数据库创建成功！");
        //建表
        [self createTable];
    } else {
        NSLog(@"怎么回事？失败了？");
    }
}

#pragma mark ================ 创建表格 ===================
- (void)createTable {
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            //单引号‘’中为表哥的字段名，都好后面为字段所属类型，字段类型是整形就用interger，字符串就用text。
            //
            NSString *sql_userInfo = @"CREATE TABLE IF NOT EXISTS UserInfoDB ('userid' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,username text NOT NULL,password text NOT NULL,status text NOT NULL,phone text,image text);";
            
            BOOL res_userinfo = [db executeUpdate:sql_userInfo];
            NSLog(@"%@",res_userinfo ? @"创建表格成功" : @"创建表格失败");
        } else {
            NSLog(@"打开数据库失败：creatTable");
        }
    }];
}
/**
* 往数据库插入数据
*
* @param nil
* @param nil
*/
- (BOOL)insertUserInfo:(NSDictionary *)dic {
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSString *sql = @"INSERT OR REPLACE INTO UserInfoDB(username, password, status, phone, image) VALUES (?,?,?,?,?);";
            
            BOOL res = [db executeUpdate:sql, dic[@"username"],dic[@"password"],dic[@"status"],dic[@"phone"],dic[@"image"]];
            
            if (!res) {
                NSLog(@"增加失败");
                result = NO;
            } else {
                NSLog(@"增加成功");
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    return result;
}

/**
 * 获取某一条数据
 *
 * @param NSDictionary
 */
- (NSDictionary *)queryUserInfo:(NSString *)userName {
    __block NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM UserInfoDB WHERE username = ?";
            
            FMResultSet *rs = [db executeQuery:sql, userName];
            
            while ([rs next]) {
                NSString *userid = [rs stringForColumn:@"userid"];
                NSString *username = [rs stringForColumn:@"username"];
                NSString *password = [rs stringForColumn:@"password"];
                NSString *status = [rs stringForColumn:@"status"];
                NSString *phone = [rs stringForColumn:@"phone"];
                NSString *image = [rs stringForColumn:@"image"];
                
                [user setValue:userid forKey:@"userid"];
                [user setValue:username forKey:@"username"];
                [user setValue:password forKey:@"password"];
                [user setValue:status forKey:@"status"];
                [user setValue:phone forKey:@"phone"];
                [user setValue:image forKey:@"image"];
            }
        } else {
            NSLog(@"打开数据库失败");
        }
        [db close];
    }];
    
    return user;
}

/**
* 获取所有的数据
*
* @param <#success#>
* @param <#return#>
*/
- (NSMutableArray *)queryAllUserInfo {
    __block NSMutableArray *users = [[NSMutableArray alloc] init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM UserInfoDB";
            
            FMResultSet *rs = [db executeQuery:sql];
            
            while ([rs next]) {
                NSString *userid = [rs stringForColumn:@"userid"];
                NSString *username = [rs stringForColumn:@"username"];
                NSString *password = [rs stringForColumn:@"password"];
                NSString *status = [rs stringForColumn:@"status"];
                NSString *phone = [rs stringForColumn:@"phone"];
                NSString *image = [rs stringForColumn:@"image"];
                
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setValue:userid forKey:@"userid"];
                [userInfo setValue:username forKey:@"username"];
                [userInfo setValue:password forKey:@"password"];
                [userInfo setValue:status forKey:@"status"];
                [userInfo setValue:phone forKey:@"phone"];
                [userInfo setValue:image forKey:@"image"];
                
                [users addObject:userInfo];
            }
        } else {
            NSLog(@"打开数据库失败");
        }
        [db close];
    }];
    
    return users;
}

/**
* 删除数据库中的某一条数据
*
* @param <#success#>
* @param <#return#>
*/
- (BOOL)deleteUserInfo:(NSString *)userName {
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSString *sql = @"DELETE FROM UserInfoDB WHERE username = ?";
            BOOL res = [db executeUpdate:sql, userName];
            if (!res) {
                NSLog(@"删除失败");
                result = NO;
            } else {
                NSLog(@"删除成功");
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    return result;
}
/**
 * 修改数据库中的某一条数据
 *
 * @param userName 用户名
 * @param key 修改的字段名称
 * @param value 修改的值
 * @param BOOL
 */
- (BOOL)updateUserInfo:(NSString *)userName withKey:(NSString *)type withValue:(nonnull NSString *)variable {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
//            NSString *sql = @"UPDATE UserInfoDB SET WHERE  username = ?";
//            BOOL res = [db executeUpdate:sql, userName];
            
            //修改type 代表的字段
            NSString *sql2 = [NSString stringWithFormat:@"UPDATE UserInfoDB SET %@='%@' WHERE username = '%@'",type,variable,userName];
            BOOL res = [db executeUpdate:sql2];
            if (!res) {
                NSLog(@"error to UPDATE data");
                result = NO;
            } else {
                NSLog(@"success to UPDATE data");
                result = YES;
            }
            [db close];
        }
    }];
    return result;
}
/**
* 判断是否存在某一个数据
*
* @param <#success#>
* @param <#return#>
*/
- (BOOL)isExistUserInfo:(NSString *)userName {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"SELECT * FROM UserInfoDB WHERE username = ?";
            FMResultSet *rs = [db executeQuery:sql, userName];
            
            while ([rs next]) {
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    return result;
}
/**
* 删除数据库
*
* @param <#success#>
* @param <#return#>
*/
- (BOOL)removeUserInfo {
    __block BOOL result = NO;
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL res = [db executeUpdate:@"DELETE FROM UserInfoDB"];
            
            if (!res) {
                NSLog(@"删除数据库失败");
                result = NO;
            } else {
                NSLog(@"删除数据库成功");
                result = YES;
            }
        } else {
            NSLog(@"打开数据库失败");
            result = NO;
        }
        [db close];
    }];
    return result;
}

@end
