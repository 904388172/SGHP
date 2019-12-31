//
//  GSHistoryHandler.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/27.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSHistoryHandler.h"
#import "HttpTool.h"

static NSString *uuid=@"28457D83-2624-4A66-BDDC-F692D0213C23";

@implementation GSHistoryHandler

/**
 * 获取历史记录
 *
 * @param success
 * @param failed
 */
+ (void)getHistoryList:(NSInteger)page Success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [dic setObject:[[GSUserDefaultStatus sharedManager] returnUUID] forKey:@"uuid"];
//    [dic setObject:uuid forKey:@"uuid"];
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnOtherServerHost] path:API_History params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

/**
 * 删除历史记录
 *
 * @param success
 * @param failed
 */
+ (void)deleteHistory:(NSString *)type Success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[GSUserDefaultStatus sharedManager] returnUUID] forKey:@"uuid"];
//    [dic setObject:uuid forKey:@"uuid"];
    NSString *path = [NSString stringWithFormat:@"%@%@",API_DeleteHistory,type];
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnOtherServerHost] path:path params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

@end
