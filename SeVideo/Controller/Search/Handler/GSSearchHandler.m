//
//  GSSearchHandler.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSSearchHandler.h"
#import "HttpTool.h"

@implementation GSSearchHandler

/**
 * 发现搜索
 *
 * @param success
 * @param failed
 */
+ (void)getSearchHotSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnOtherServerHost] path:API_SearchHot params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

/**
 * 搜索
 *
 * @param success
 * @param failed
 */
+ (void)searchKey:(NSString *)key withIndex:(NSInteger)index Success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:key forKey:@"search"];
    NSString *path = [NSString stringWithFormat:@"%@%ld",API_Search,(long)index];
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnMainServerHost] path:path params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

@end
