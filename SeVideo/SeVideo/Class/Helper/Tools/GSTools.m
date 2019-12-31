//
//  GSTools.m
//  SeVideo
//
//  Created by 耿双 on 2019/8/28.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSTools.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

#define SecretKey @"GS"

@implementation GSTools

+ (NSString *)stringEncoding:(NSString *)oldStr {
    if (MAIN_TEST) {
        return [[oldStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
    } else {
//        if ([[[GSUserDefaultStatus sharedManager] returnRoleStatus] isEqualToString:@"1"]){
            return oldStr;
//        } else if ([[[GSUserDefaultStatus sharedManager] returnRoleStatus] isEqualToString:@"2"]){
//            return oldStr;
//        } else {
//            return [[oldStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
//        }
    }
//    return oldStr;
}

/**
 * 默认UI颜色
 */
+ (UIColor *)returnMainUIColor {
    if ([[[GSUserDefaultStatus sharedManager] returnMainUIColor] isEqualToString:@"0"]) {
        return RGBA(255, 105, 180,0.8);
    } else  if ([[[GSUserDefaultStatus sharedManager] returnMainUIColor] isEqualToString:@"1"]) {
        return RGBA(204, 71, 85,0.8);
        
    } else if ([[[GSUserDefaultStatus sharedManager] returnMainUIColor] isEqualToString:@"2"]) {
        return RGBA(157, 74, 204,0.8);
    }
    return RGB(135,206,250);
}

/**
 * 默认背景颜色
 */
+ (UIColor *)returnBackgroungColor {
    return RGB(254, 254, 254);
}

/**
 * 默认文字颜色
 */
+ (UIColor *)returnTextColor {
    return RGB(51, 51, 51);
}

/**
 * 默认辅助文字颜色
 */
+ (UIColor *)returnDetailColor {
    return RGB(102, 102, 102);
}

/**
 * 默认线的颜色
 */
+ (UIColor *)returnSeparateColor {
    return RGB(238, 238, 238);
}


//对NSData 进行加密
+ (NSData *)encryptDataWithData:(NSData *)data Key:(NSString *)key {
    key = SecretKey;
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(key) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if(cryptStatus == kCCSuccess)  {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
// 解密
+ (NSData *)decryptDataWithData:(NSData *)data andKey:(NSString *)key {
    key = SecretKey;
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}
//NSString加密
+ (NSString *)encryptStringWithString:(NSString *)string andKey:(NSString *)key {
    key = SecretKey;
    const char *cStr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:[string length]];
    //对数据进行加密
    NSData *result = [[self class] encryptDataWithData:data Key:key];
    //转换为2进制字符串
    if(result && result.length > 0) {
        Byte *datas = (Byte *)[result bytes];
        NSMutableString *outPut = [NSMutableString stringWithCapacity:result.length];
        for(int i = 0 ; i < result.length ; i++) {
            [outPut appendFormat:@"%02x",datas[i]];
        }
        return outPut;
    }
    return nil;
}
//NSString解密
+ (NSString *)decryptStringWithString:(NSString *)string andKey:(NSString *)key {
    key = SecretKey;
    NSMutableData *data = [NSMutableData dataWithCapacity:string.length/2.0];
    unsigned char whole_bytes;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for(i = 0 ; i < [string length]/2 ; i++) {
        byte_chars[0] = [string characterAtIndex:i * 2];
        byte_chars[1] = [string characterAtIndex:i * 2 + 1];
        whole_bytes = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_bytes length:1];
    }
    NSData *result = [[self class] decryptDataWithData:data andKey:key];
    if(result && result.length > 0){
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
