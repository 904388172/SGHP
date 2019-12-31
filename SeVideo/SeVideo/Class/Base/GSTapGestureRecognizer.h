//
//  GSTapGestureRecognizer.h
//  SeVideo
//
//  Created by 耿双 on 2019/8/28.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSBtnModel;
@class GSAdvModel;
@class GSMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface GSTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) GSBtnModel *btnModel;

@property (nonatomic, strong) GSAdvModel *advModel;

@property (nonatomic, strong) GSMainModel *cellModel;


@end

NS_ASSUME_NONNULL_END
