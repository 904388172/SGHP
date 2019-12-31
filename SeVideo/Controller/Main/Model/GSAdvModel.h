//
//  GSAdvModel.h
//  SeVideo
//
//  Created by 耿双 on 2019/11/12.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSAdvModel : NSObject

@property (nonatomic, assign) long status;
@property (nonatomic, assign) long ID;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *deleted_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *urlname;
@property (nonatomic, copy) NSString *imgpatch;
@property (nonatomic, assign) long place_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
