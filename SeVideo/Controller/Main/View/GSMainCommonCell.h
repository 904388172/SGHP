//
//  GSMainCommonCell.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/11.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMainModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GSMainCommonCell;
@protocol MainCommonCellDelegate <NSObject>

- (void)mainCommonCell:(GSMainCommonCell *)mainCommonCell didSelectModel:(id)model;

@end

@interface GSMainCommonCell : UITableViewCell

@property (nonatomic, weak) id<MainCommonCellDelegate> delegate;

@property (nonatomic, strong) GSMainModel *cellLeftModel;
@property (nonatomic, strong) GSMainModel *cellRightModel;

@end

NS_ASSUME_NONNULL_END
