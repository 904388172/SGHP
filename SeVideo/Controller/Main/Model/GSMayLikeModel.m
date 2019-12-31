//
//  GSMayLikeModel.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/11.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSMayLikeModel.h"

@implementation GSMayLikeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"ID":@"id",
             };
}

@end
