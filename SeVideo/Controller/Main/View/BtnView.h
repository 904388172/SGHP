//
//  BtnView.h
//  SeVideo
//
//  Created by 耿双 on 2019/11/11.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSBtnModel.h"

@class BtnView;
NS_ASSUME_NONNULL_BEGIN
@protocol BtnViewDidSelected <NSObject>

//- (void)btnViewDidSelected:(BtnView *)btnView withBtnModel:(GSBtnModel *)model;
- (void)btnViewDidSelected:(BtnView *)btnView withIndex:(NSInteger)index;

@end

@interface BtnView : UIView

@property (nonatomic, strong) NSArray <GSBtnModel *>*btnItems;
@property (nonatomic, weak) id<BtnViewDidSelected> delegate;

@end

NS_ASSUME_NONNULL_END
