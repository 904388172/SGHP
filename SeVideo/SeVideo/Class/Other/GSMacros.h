//
//  GSMacros.h
//  SeVideo
//
//  Created by 耿双 on 2019/8/12.
//  Copyright © 2019 GS. All rights reserved.
//
/**
 * 宏
 */

#ifndef GSMacros_h
#define GSMacros_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEFAULT_INTERVAL 24
#define RGB(x,y,z) [UIColor colorWithRed:(x/255.0) green:(y/255.0) blue:(z/255.0) alpha:1]
#define RGBA(x,y,z,a) [UIColor colorWithRed:(x/255.0) green:(y/255.0) blue:(z/255.0) alpha:a]


//是否是测试，是测试就是1，否则就是0
#define MAIN_TEST 1

#endif /* GSMacros_h */
