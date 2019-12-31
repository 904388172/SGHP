//
//  GSSearchListModel.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSSearchListModel : NSObject

@property (nonatomic, assign) long ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *coverpath;
@property (nonatomic, copy) NSString *coverpath1;

@end

NS_ASSUME_NONNULL_END
