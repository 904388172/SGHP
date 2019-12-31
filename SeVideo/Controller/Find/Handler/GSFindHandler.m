//
//  GSFindHandler.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSFindHandler.h"
#import "HttpTool.h"

@implementation GSFindHandler

/**
 * 获取发现列表
 *
 * @param success
 * @param failed
 */
+ (void)getVideoExplorePage:(NSInteger)page Success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnOtherServerHost] path:API_Explore params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}


@end
