//
//  GSSearchHandler.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSBaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSSearchHandler : GSBaseHandler

/**
 * 发现搜索
 *
 * @param success
 * @param failed
 */
+ (void)getSearchHotSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 * 搜索
 *
 * @param success
 * @param failed
 */
+ (void)searchKey:(NSString *)key withIndex:(NSInteger)index Success:(SuccessBlock)success failed:(FailedBlock)failed;


@end

NS_ASSUME_NONNULL_END
