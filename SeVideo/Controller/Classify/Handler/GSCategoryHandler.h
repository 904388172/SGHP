//
//  GSCategoryHandler.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/23.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSBaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSCategoryHandler : GSBaseHandler

/**
 * 获取分类列表
 *
 * @param type 类型
 * @param videoId id
 * @param index 分页
 */
+ (void)getCategoryList:(NSString *)type
            withVideoId:(NSInteger)videoId
              withIndex:(NSInteger)index
                Success:(SuccessBlock)success failed:(FailedBlock)failed;

@end

NS_ASSUME_NONNULL_END
