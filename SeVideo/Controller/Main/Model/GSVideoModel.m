//
//  GSVideoModel.m
//  SeVideo
//
//  Created by 耿双 on 2019/11/8.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSVideoModel.h"

@implementation GSVideoModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"ID":@"id",
             };
}
@end
