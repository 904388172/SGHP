//
//  GSMainHandler.h
//  SeVideo
//
//  Created by 耿双 on 2019/11/8.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSBaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSMainHandler : GSBaseHandler

//测试接口
+ (void)testUrl:(NSString *)url success:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 * 获取轮播信息
 *
 * @param success
 * @param failed
 */
+ (void)getAdInfoSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 * 获取按钮列表
 *
 * @param success
 * @param failed
 */
+ (void)getSortListSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 * 获取推荐喜欢列表
 *
 * @param success
 * @param failed
 */
+ (void)getMayLike:(NSInteger)page success:(SuccessBlock)success failed:(FailedBlock)failed;


/**
 * 获取首页默认信息
 *
 * @param success
 * @param failed
 */
+ (void)getMainDataSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

@end

NS_ASSUME_NONNULL_END
