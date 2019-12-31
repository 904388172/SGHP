//
//  GSDetailModel.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/23.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSDetailModel.h"

@implementation GSDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"ID":@"id",
             };
}
/**
 模型中的属性有数组
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 如果属性是数组，重写模型方法；
 */
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"labls" : [GSLablsModel class]};
}

@end
