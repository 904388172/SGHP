//
//  GSExploreModel.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSExploreModel : NSObject

@property (nonatomic, assign) long is_ad;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) long pageviews;
@property (nonatomic, assign) long ID;
@property (nonatomic, copy) NSString *coverpath;
@property (nonatomic, copy) NSString *coverpath1;

@end

NS_ASSUME_NONNULL_END
