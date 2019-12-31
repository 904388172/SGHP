//
//  GSPlayHandler.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/23.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSBaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSPlayHandler : GSBaseHandler

/**
 * 播放详情
 *
 * @param videoId id
 */
+ (void)playVideoId:(NSInteger)videoId Success:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 * 标签列表
 *
 * @param videoId id
 */
+ (void)getTopicList:(NSInteger)videoId withPage:(NSInteger)page Success:(SuccessBlock)success failed:(FailedBlock)failed;

@end

NS_ASSUME_NONNULL_END
