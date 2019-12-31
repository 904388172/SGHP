//
//  GSDetailModel.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/23.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSLablsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSDetailModel : NSObject

@property (nonatomic, assign) long ID;
@property (nonatomic, copy) NSString * authername;
@property (nonatomic, assign) long pageviews;
@property (nonatomic, copy) NSString * auther;
@property (nonatomic, copy) NSString * coverpath;
@property (nonatomic, copy) NSString * coverpath1;
@property (nonatomic, copy) NSString * introduction;
@property (nonatomic, copy) NSString * create_at;
@property (nonatomic, strong) NSMutableArray<GSLablsModel *> *labls;
//属性字段包含另一个模型时需要添加一个模型
@property (nonatomic, strong) GSLablsModel *lablsModel;
@property (nonatomic, assign) long sort_id;
@property (nonatomic, copy) NSString * deleted_at;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * videopath;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, assign) long is_vip;
@property (nonatomic, copy) NSString * auther_no;
@property (nonatomic, copy) NSString * is_like;

@end

NS_ASSUME_NONNULL_END
