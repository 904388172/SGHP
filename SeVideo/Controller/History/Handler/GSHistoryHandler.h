//
//  GSHistoryHandler.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/27.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSBaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSHistoryHandler : GSBaseHandler

/**
 * 获取历史记录
 *
 * @param success
 * @param failed
 */
+ (void)getHistoryList:(NSInteger)page Success:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 * 删除历史记录
 *
 * @param success
 * @param failed
 */
+ (void)deleteHistory:(NSString *)type Success:(SuccessBlock)success failed:(FailedBlock)failed;


@end

NS_ASSUME_NONNULL_END
