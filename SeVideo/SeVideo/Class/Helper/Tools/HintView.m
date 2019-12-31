//
//  HintView.m
//
//  Created by GS on 17-11-03.
//  Copyright (c) 2017年 GS. All rights reserved.
//

#import "HintView.h"
#import <QuartzCore/QuartzCore.h>

#define UI_FRAME_ZERO 64
@interface HintView ()
{
    NSTimer *timer;
}

// 自定义提示标签显示的时间 默认为3s
@property (nonatomic, assign)NSTimeInterval customTimeVal;

@end

@implementation HintView

+(instancetype)showInCurrentViewWithMessage:(NSString *)message {
    if (message == nil || message == NULL || [message isEqualToString:@""]) {
        message = @"操作失败";
    }
    HintView *hint = [[self alloc] initWith:message];
    [hint showInView];
    return hint;
}
-(id)initWith:(NSString*)message
{
    self=[super init];
    if(self)
    {
        // 默认为3s
        self.customTimeVal = 3;
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.layer.cornerRadius=10;
        self.layer.masksToBounds=YES;
        self.layer.opacity = 0;
        UILabel *label=[[UILabel alloc]init];
        [self addSubview:label];
        label.numberOfLines=0;
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:12.0f];
        label.backgroundColor=[UIColor colorWithWhite:255 alpha:0];
        label.textColor=[UIColor whiteColor];
        label.text=message;
        //屏幕size
        CGSize screenSize=[[UIScreen mainScreen]bounds].size;
        //view最大宽度
        float maxWidth=screenSize.width-80;
        
        
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};//指定字号
        //高度固定不折行，根据字的多少计算label的宽度
        CGSize sizeW = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        //高度固定不折行，根据字的多少计算label的宽度
        CGSize sizeH = [message boundingRectWithSize:CGSizeMake(maxWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        
        //未达到限制宽度
        if(sizeW.width<maxWidth-40)
        {
            [self setFrame:CGRectMake((screenSize.width-sizeW.width)/2-20, screenSize.height- UI_FRAME_ZERO-120, sizeW.width+40, sizeW.height+16)];
            [label setFrame:CGRectMake(20, 8, sizeW.width, sizeW.height)];
        }
        //
        else
        {
            if(sizeH.height + 75 > 120)
            {
                [self setFrame:CGRectMake((screenSize.width-sizeH.width)/2-20, screenSize.height- UI_FRAME_ZERO- sizeH.height - 75,sizeH.width+40, sizeH.height+16)];
            }
            else
            {
                [self setFrame:CGRectMake((screenSize.width-sizeH.width)/2-20, screenSize.height- UI_FRAME_ZERO-120,sizeH.width+40, sizeH.height+16)];
            }
            [label setFrame:CGRectMake(20, 8, sizeH.width, sizeH.height)];
        }
        
    }
    return self;
}
-(void)showInView
{
    //强制主线程更新画面
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //  防止快速点击出现提示重叠
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        for (UIView *lastView in window.rootViewController.view.subviews) {
            
            if ([lastView isKindOfClass:[HintView class]]) {
                [lastView removeFromSuperview];
            }
        }
        
        [window.rootViewController.view addSubview:self];
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             self.layer.opacity=1;
         }completion:^(BOOL finish){}];
        //
        timer=[NSTimer scheduledTimerWithTimeInterval:self.customTimeVal target:self selector:@selector(miss) userInfo:nil repeats:NO];
    });
   
}

-(void)showInView:(UIView*)view
{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //  防止快速点击出现提示重叠
        for (UIView *lastView in view.subviews) {
            
            if ([lastView isKindOfClass:[HintView class]]) {
                [lastView removeFromSuperview];
            }
        }
        
        [view addSubview:self];
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             self.layer.opacity=1;
         }completion:^(BOOL finish){}];
        //
        timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(miss) userInfo:nil repeats:NO];
    });
    
}
-(void)miss
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         self.layer.opacity=0;

     }completion:^(BOOL finish)
    {
        [self removeFromSuperview];
    }];
}
@end
