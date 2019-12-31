//
//  HintView.m
//
//  Created by GS on 17-11-03.
//  Copyright (c) 2017年 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HintView : UIView
/**
 *  message  提示信息（不传默认提示操作失败）
 */
//单利方法
+(instancetype)showInCurrentViewWithMessage:(NSString *)message;

@end
