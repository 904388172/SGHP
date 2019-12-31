//
//  GSLablsModel.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/24.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSLablsModel : NSObject

@property (nonatomic, assign) long ID;
@property (nonatomic, strong) NSDictionary * pivot;
@property (nonatomic, copy) NSString * create_at;
@property (nonatomic, copy) NSString * deleted_at;
@property (nonatomic, copy) NSString * order;
@property (nonatomic, copy) NSString * Description;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * cover;

@end

NS_ASSUME_NONNULL_END
