//
//  BtnView.m
//  SeVideo
//
//  Created by 耿双 on 2019/11/11.
//  Copyright © 2019 GS. All rights reserved.
//

#import "BtnView.h"
#import "GSTapGestureRecognizer.h"

@implementation BtnView

- (void)setBtnItems:(NSArray<GSBtnModel *> *)btnItems {
    CGFloat width = (SCREEN_WIDTH - DEFAULT_INTERVAL*5) / 4;
    CGFloat height = width+25;
    for (NSInteger i = 0 ; i < btnItems.count+1; i++) {
        GSBtnModel *model;
        if (i == btnItems.count) {
            model = btnItems[i-1];
        } else {
            model = btnItems[i];
        }
        
        UIView *btnView = [[UIView alloc] init];
        btnView.userInteractionEnabled = YES;
        if (i / 4 == 0) {
            btnView.frame = CGRectMake(DEFAULT_INTERVAL + DEFAULT_INTERVAL*i+ i*width, DEFAULT_INTERVAL/2, width, height);
        } else {
            btnView.frame = CGRectMake(DEFAULT_INTERVAL + DEFAULT_INTERVAL*(i-4)+ (i-4)*width, height+DEFAULT_INTERVAL/2, width, height);
        }
        [self addSubview:btnView];
        
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(0 , 0, btnView.width, btnView.height-25);
        if (!MAIN_TEST) {
            [item sd_setBackgroundImageWithURL:[NSURL URLWithString:model.icopath] forState:UIControlStateNormal];
        } else {
            [item sd_setBackgroundImageWithURL:[NSURL URLWithString:model.icopath1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"dahuan"]];
        }
        [item addTarget:self action:@selector(btnItemsClick:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = i;
        item.layer.cornerRadius = 3.0;
        [btnView addSubview:item];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, item.height + 5, item.width, 20)];
        if (i == btnItems.count) {
            nameLabel.text = @"全部分类";
        } else {
            nameLabel.text = [GSTools stringEncoding:model.name];
        }
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [GSTools returnTextColor];
        [btnView addSubview:nameLabel];
    }
}

- (void)btnItemsClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnViewDidSelected:withIndex:)]) {
        [self.delegate btnViewDidSelected:self withIndex:sender.tag];
    }
}
@end
