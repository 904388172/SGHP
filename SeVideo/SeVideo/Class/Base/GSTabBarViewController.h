//
//  GSTabBarViewController.h
//  SeVideo
//
//  Created by 耿双 on 2019/8/14.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GSAPPType) {
    GSAPPTypeVideo = 1, //视频
    GSAPPTypeAudio, //播放器
};

NS_ASSUME_NONNULL_BEGIN

@interface GSTabBarViewController : UITabBarController

@end

NS_ASSUME_NONNULL_END
