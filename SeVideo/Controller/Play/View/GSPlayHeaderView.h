//
//  GSPlayHeaderView.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/25.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSDetailModel.h"


@protocol tipBtnClickDelegate <NSObject>

- (void)tipBtnClick:(GSLablsModel *_Nullable)model;

@end
NS_ASSUME_NONNULL_BEGIN

@interface GSPlayHeaderView : UIView

@property (nonatomic, weak) id<tipBtnClickDelegate>delegate;

@property (nonatomic, strong) GSDetailModel *model;

- (CGFloat)getViewHeight;

@end

NS_ASSUME_NONNULL_END
