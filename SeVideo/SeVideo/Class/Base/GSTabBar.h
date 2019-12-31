//
//  GSTabBar.h
//  SeVideo
//
//  Created by 耿双 on 2019/8/14.
//  Copyright © 2019 GS. All rights reserved.
//
/**
 * 自定义tabbar
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GSItemType) {
    GSItemTypeLive = 100, //展示直播
    GSItemTypeMe, //我的
};

@class GSTabBar;

typedef void(^TabBlock)(GSTabBar * _Nullable tabbar, GSItemType idx);

@protocol GSTabBarDelegate <NSObject>

-(void)tabbar:(GSTabBar *_Nullable)tabbar clickButton:(GSItemType)index;

@end
NS_ASSUME_NONNULL_BEGIN

@interface GSTabBar : UIView

//代理
@property (nonatomic, weak) id<GSTabBarDelegate>delegate;

//block
@property (nonatomic, copy) TabBlock block;


@end

NS_ASSUME_NONNULL_END
