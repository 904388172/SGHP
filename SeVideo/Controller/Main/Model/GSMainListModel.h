//
//  GSMainListModel.h
//  SeVideo
//
//  Created by 耿双 on 2019/11/8.
//  Copyright © 2019 GS. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GSMainModel.h"
#import "GSVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSMainListModel : GSMainModel

@property (nonatomic, strong) NSMutableArray<GSVideoModel *> *list;
//属性字段包含另一个模型时需要添加一个模型
@property (nonatomic, strong) GSVideoModel *videoModel;

@property (nonatomic, assign) long is_ad;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) long type;
@property (nonatomic, assign) long type_id;

//广告
@property (nonatomic, assign) long status;
@property (nonatomic, assign) long ID;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *deleted_at;
@property (nonatomic, copy) NSString *urlname;
@property (nonatomic, copy) NSString *imgpath;
@property (nonatomic, assign) long place_id;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *url;


@end

NS_ASSUME_NONNULL_END
