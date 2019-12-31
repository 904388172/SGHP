//
//  GSBtnModel.h
//  SeVideo
//
//  Created by 耿双 on 2019/11/11.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSBtnModel : NSObject

@property (nonatomic, assign) long ID;
@property (nonatomic, assign) long order;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *deleted_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icopath;
@property (nonatomic, copy) NSString *icopath1;

@end

NS_ASSUME_NONNULL_END
