//
//  GSTabBar.m
//  SeVideo
//
//  Created by 耿双 on 2019/8/14.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSTabBar.h"

@interface GSTabBar ()

//tabbar的背景图
@property (nonatomic, strong) UIImageView *tabbgView;
@property (nonatomic, strong) NSArray *itemsList;
@property (nonatomic, strong) NSArray *itemsTitleList;
@property (nonatomic ,strong) UIButton *lastItem; //上一个item

@end

@implementation GSTabBar

- (NSArray *)itemsList {
    if (!_itemsList) {
        if (G_CARRIR_TYPE == CARRIER_TYPE_MAIN) {
            _itemsList = @[@"tab_live",@"tab_me",@"tab_live"];
            
        } else {
            _itemsList = @[@"tab_me",@"tab_live",@"tab_me",@"tab_live"];
        }
    }
    return _itemsList;
}
- (NSArray *)itemsTitleList {
    if (!_itemsTitleList) {
        if (G_CARRIR_TYPE == CARRIER_TYPE_MAIN) {
            _itemsTitleList = @[@"首页",@"发现",@"我的"];
        } else {
            _itemsTitleList = @[@"首页",@"分类",@"发现",@"我的"];
        }
    }
    return _itemsTitleList;
}
- (UIImageView *)tabbgView {
    if (!_tabbgView) {
        _tabbgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
    }
    return _tabbgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //装载背景图
        [self addSubview:self.tabbgView];
        
        UIImage *img = [UIImage imageNamed:self.itemsList[0]];
        CGFloat imageW = img.size.width;
        CGFloat imageH = img.size.height;
        
        //创建几个按钮
        for (NSInteger i = 0; i < self.itemsList.count; i++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.tag = GSItemTypeLive + i;
            //不让图片在高亮下改变
            item.adjustsImageWhenHighlighted = NO;
            
            [item setImage:[UIImage imageNamed:self.itemsList[i]] forState:UIControlStateNormal];
            [item setTitle:self.itemsTitleList[i] forState:UIControlStateNormal];
            [item setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
//            [item setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, -imageH - 10, 0.f)];
            [item setImage:[UIImage imageNamed:[self.itemsList[i] stringByAppendingString:@"_p"]] forState:UIControlStateSelected];
            [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                item.selected = YES;
                self.lastItem = item;
            }
            [self addSubview:item];
        }
    }
    return self;
}
//设置item的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tabbgView.frame = self.bounds;
    CGFloat width = self.bounds.size.width / self.itemsList.count;
    for (NSInteger i = 0; i < [self subviews].count; i++) {
        UIView *btn = [self subviews][i];
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.frame = CGRectMake((btn.tag - GSItemTypeLive)*width, 0, width, self.bounds.size.height);
        }
    }
}
- (void)clickItem:(UIButton *)sender {
    //如果用代理走代理 (二选一)
    if ([self.delegate respondsToSelector:@selector(tabbar:clickButton:)]) {
        [self.delegate tabbar:self clickButton:sender.tag];
    }
    
    //如果用block走block
    //!self.block?:self.block(self, sender.tag); //和下面是一个意思
    if (self.block) {
        self.block(self, sender.tag);
    }
    
    //选中改变图片
    self.lastItem.selected = NO;
    sender.selected = YES;
    self.lastItem = sender;
    
    //设置动画
    [UIView animateWithDuration:0.2 animations:^{
        //将button扩大1.2倍
        sender.transform = CGAffineTransformMakeScale(1.2, 1.2); // 宽高放大1.2倍
    } completion:^(BOOL finished) {
        //恢复原始状态
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform = CGAffineTransformIdentity;
        }];
    }];
}
@end
