//
//  GSFindHandler.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSBaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSFindHandler : GSBaseHandler

/**
 * 获取发现列表
 *
 * @param success
 * @param failed
 */
+ (void)getVideoExplorePage:(NSInteger)page Success:(SuccessBlock)success failed:(FailedBlock)failed;


@end

NS_ASSUME_NONNULL_END
