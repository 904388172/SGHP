//
//  GSMainHandler.m
//  SeVideo
//
//  Created by 耿双 on 2019/11/8.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSMainHandler.h"
#import "HttpTool.h"

@implementation GSMainHandler

/**
 * 获取按钮列表
 *
 * @param success
 * @param failed
 */
+ (void)getSortListSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnMainServerHost] path:API_Sorts params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}
/**
 * 获取轮播信息
 *
 * @param success
 * @param failed
 */
+ (void)getAdInfoSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnMainServerHost] path:API_ADV params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

/**
 * 获取推荐喜欢列表
 *
 * @param success
 * @param failed
 */
+ (void)getMayLike:(NSInteger)page success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnMainServerHost] path:API_MayLike params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

/**
 * 获取首页详细
 *
 * @param success
 * @param failed
 */
+ (void)getMainDataSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnMainServerHost] path:API_Index params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

+ (void)testUrl:(NSString *)url success:(SuccessBlock)success failed:(FailedBlock)failed {
    [HttpTool getWithHost:url path:@"" params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

@end
