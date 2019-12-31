//
//  GSBaseHandler.h
//  SeVideo
//
//  Created by 耿双 on 2019/8/15.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//定义一些block
/**
 * 处理完成事件
 */
typedef void(^CompleteBlock)(void);
/**
 * 处理事件成功
 * @param obj 返回数据
 */
typedef void(^SuccessBlock)(id obj);

/**
 * 处理事件失败
 * @param obj 错误信息
 */
typedef void(^FailedBlock)(id obj);


@interface GSBaseHandler : NSObject

@end

NS_ASSUME_NONNULL_END
