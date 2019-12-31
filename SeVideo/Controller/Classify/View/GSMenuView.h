//
//  GSMenuView.h
//  SeVideo
//
//  Created by 耿双 on 2019/12/18.
//  Copyright © 2019 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSBtnModel.h"

@protocol GSTopMenuDelegate <NSObject>

@optional
/* ScrollView Menu Button Click Delegate */
-(void)selectTopMenu:(GSBtnModel *_Nullable)model;
@end

NS_ASSUME_NONNULL_BEGIN

@interface GSMenuView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<GSTopMenuDelegate> topMenuDelegate;

- (void)calcurateWidth:(NSArray *)menuList;


@property (nonatomic, assign) long selectID;


@end

NS_ASSUME_NONNULL_END
