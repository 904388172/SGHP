//
//  GSTools.h
//  SeVideo
//
//  Created by 耿双 on 2019/8/28.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSTools : NSObject

+ (NSString *)stringEncoding:(NSString *)oldStr;

/**
 * 默认UI颜色
 */
+ (UIColor *)returnMainUIColor;

/**
 * 默认背景颜色
 */
+ (UIColor *)returnBackgroungColor;

/**
 * 默认文字颜色
 */
+ (UIColor *)returnTextColor;

/**
 * 默认辅助文字颜色
 */
+ (UIColor *)returnDetailColor;

/**
 * 默认线的颜色
 */
+ (UIColor *)returnSeparateColor;


/**
 * NSString加密
 * key 加密密钥
 */
+ (NSString *)encryptStringWithString:(NSString *)string andKey:(NSString *)key;

/**
 * NSString解密
 * key 加密密钥
 */
+ (NSString *)decryptStringWithString:(NSString *)string andKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
