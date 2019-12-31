//
//  GSCategoryHandler.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/23.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSCategoryHandler.h"
#import "HttpTool.h"

@implementation GSCategoryHandler

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
                  Success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:type forKey:@"orderby"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"page"];
    NSString *path = [NSString stringWithFormat:@"%@%ld",API_Category,(long)videoId];
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnMainServerHost] path:path params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

@end
