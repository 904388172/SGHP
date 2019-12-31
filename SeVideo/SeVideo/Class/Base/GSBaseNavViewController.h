//
//  GSBaseNavViewController.h
//  SeVideo
//
//  Created by 耿双 on 2019/8/14.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSBaseNavViewController : UINavigationController

/** 使全屏滑动生效*/
- (void)enabledPopGestureRecognizer;

/** 禁用全屏滑动*/
- (void)disabledPopGestureRecognizer;

/** 隐藏左上角返回按钮*/
- (void)setBackButtonHidden;

@end

NS_ASSUME_NONNULL_END
