//
//  GSPlayHandler.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/23.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSPlayHandler.h"
#import "HttpTool.h"

@implementation GSPlayHandler

/**
 * 播放详情
 *
 * @param videoId id
 */
+ (void)playVideoId:(NSInteger)videoId Success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[[GSUserDefaultStatus sharedManager]  returnUUID] forKey:@"uuid"];
    NSString *path = [NSString stringWithFormat:@"%@%ld",API_Play,(long)videoId];
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnMainServerHost] path:path params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

/**
 * 标签列表
 *
 * @param videoId id
 */
+ (void)getTopicList:(NSInteger)videoId withPage:(NSInteger)page Success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    
    NSString *path = [NSString stringWithFormat:@"%@%ld",API_Topic,(long)videoId];
    [HttpTool getWithHost:[[GSUserDefaultStatus sharedManager] returnMainServerHost] path:path params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

@end
