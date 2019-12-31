//
//  GSBaseNavViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/8/14.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSBaseNavViewController.h"

@interface GSBaseNavViewController ()<UIGestureRecognizerDelegate>

/** 全屏手势*/
@property(nonatomic, strong) UIPanGestureRecognizer *pan;

/** 返回按钮*/
@property(nonatomic, strong) UIButton *backButton;

@end

@implementation GSBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //修改系统导航的样式
    [self setCommonNavigationStyle];
    
    // 获取系统自带滑动手势的对象
    id target = self.interactivePopGestureRecognizer.delegate;
    
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法handleNavigationTransition
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
    // 设置手势代理，拦截手势触发
    self.pan.delegate = self;
    
    // 添加手势
    [self.view addGestureRecognizer:self.pan];
    
    // 取消系统自带的滑动
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)setCommonNavigationStyle {
    [self.navigationBar setBackgroundImage:[self imageWithColor:[GSTools returnMainUIColor]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"global_tittle_bg"] forBarMetrics:UIBarMetricsDefault];
    
    // 取消navigationBar的模糊效果
    self.navigationBar.translucent = NO;
    
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Heiti TC" size:17]}];
}
//根据颜色生成image
- (UIImage *)imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开始画图的上下文
    UIGraphicsBeginImageContext(rect.size);

    // 设置背景颜色
    [color set];
    // 设置填充区域
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));

    // 返回UIImage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

#pragma marks - UIGestureRecognizerDelegate
/** 什么时候调用：每次触发手势之前都会询问下代理，是否触发。拦截手势触发*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    for (UIViewController *viewController in self.viewControllers) {
        CGPoint translatedPoint = [pan translationInView:viewController.view];
        if (translatedPoint.x > 0) {
            if (self.viewControllers.count == 1) {
                // 表示用户在根控制器界面，就不需要触发滑动手势，
                return NO;
            }
            
            // 首先取消网络加载转圈
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            return YES;
        }
    }
    return NO;
}
/**
 *  重写这个方法的目的:为了拦截整个push过程,拿到所有push进来的子控制器
 *
 *  @param viewController 是当前push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断当前控制器是不是第一级控制器时设置下放的控制栏和上方的导航条左侧按钮
    if (self.viewControllers.count > 0) {
        [self hideBottonBar:viewController];
        [self setLeftBarButton:viewController];
    }
    
    [super pushViewController:viewController animated:animated];
}

/** 判断为不是第一级控制器就隐藏下放的控制栏*/
- (void)hideBottonBar:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
}

/** 判断为不是第一级控制器就设置导航条的左边按钮为返回图标*/
- (void)setLeftBarButton:(UIViewController *)viewController {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"global_back"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.backButton = button;
    
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)enabledPopGestureRecognizer {
    self.pan.enabled = YES;
}

- (void)disabledPopGestureRecognizer {
    self.pan.enabled = NO;
}

- (void)setBackButtonHidden {
    self.backButton.hidden = YES;
}

/** 返回*/
- (void)back {
    // 首先取消网络加载转圈
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self popViewControllerAnimated:YES];
}

@end
