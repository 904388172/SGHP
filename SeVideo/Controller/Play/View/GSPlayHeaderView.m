//
//  GSPlayHeaderView.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/25.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSPlayHeaderView.h"

@interface GSPlayHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *nLabel;

@property (nonatomic, strong) NSMutableArray *lablsArray;

@end

@implementation GSPlayHeaderView

- (NSMutableArray *)lablsArray {
    if (!_lablsArray) {
        _lablsArray = [[NSMutableArray alloc] init];
    }
    return _lablsArray;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [GSTools returnTextColor];
    }
    return _titleLabel;
}
- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont boldSystemFontOfSize:16];
        _numLabel.textColor = [GSTools returnTextColor];
    }
    return _numLabel;
}
- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc] init];
    }
    return _tipView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont boldSystemFontOfSize:16];
        _leftLabel.textColor = [GSTools returnTextColor];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont boldSystemFontOfSize:16];
        _rightLabel.textColor = [GSTools returnTextColor];
        _rightLabel.numberOfLines = 0;
    }
    return _rightLabel;
}
- (UILabel *)nLabel {
    if (!_nLabel) {
        _nLabel = [[UILabel alloc] init];
        _nLabel.font = [UIFont boldSystemFontOfSize:16];
        _nLabel.textColor = [GSTools returnTextColor];
    }
    return _nLabel;
}


- (void)setModel:(GSDetailModel *)model {
    self.titleLabel.text = [GSTools stringEncoding:model.title];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(DEFAULT_INTERVAL/2);
        make.right.mas_equalTo(self.mas_right).offset(-DEFAULT_INTERVAL/2);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(30);
    }];
    
    self.numLabel.text = [NSString stringWithFormat:@"%@%@%ld%@",model.updated_at,@"播放",model.pageviews / 10000,@"万次"];
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(DEFAULT_INTERVAL/2);
        make.right.mas_equalTo(self.mas_right).offset(-DEFAULT_INTERVAL/2);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    self.tipView.userInteractionEnabled = YES;
    [self addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.numLabel.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    for (UIButton *btn in self.tipView.subviews) {
        [btn removeFromSuperview];
    }
    float marginLeft = DEFAULT_INTERVAL/2;
    self.lablsArray = model.labls;
    for (int i = 0; i < model.labls.count; i++) {
        GSLablsModel *lablsModel = [[GSLablsModel alloc] init];
        lablsModel = model.labls[i];
        float sizeWidth = [lablsModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size.width + DEFAULT_INTERVAL;
        
        UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipBtn setTitle:[GSTools stringEncoding:lablsModel.name] forState:UIControlStateNormal];
        [tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        tipBtn.backgroundColor = RGB(255, 105, 180);
        tipBtn.layer.cornerRadius = 6;
        tipBtn.layer.borderWidth = 1;
        tipBtn.layer.borderColor = RGB(255, 105, 180).CGColor;
        [self.tipView addSubview:tipBtn];
        [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tipView.mas_left).offset(marginLeft);
            make.top.mas_equalTo(self.tipView.mas_top);
            make.width.mas_equalTo(sizeWidth);
            make.height.mas_equalTo(30);
        }];
        marginLeft += sizeWidth+DEFAULT_INTERVAL;
        tipBtn.tag = i;
        [tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.leftLabel.text = @"简介:";
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(DEFAULT_INTERVAL/2);
        make.top.mas_equalTo(self.tipView.mas_bottom);
        make.width.mas_equalTo(60);
    }];
    
   
    self.rightLabel.text = [GSTools stringEncoding:model.introduction];
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(DEFAULT_INTERVAL/2);
        make.top.mas_equalTo(self.leftLabel.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-DEFAULT_INTERVAL/2);
    }];
    
   
    self.nLabel.text = @"猜你喜欢:";
    [self addSubview:self.nLabel];
    [self.nLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(DEFAULT_INTERVAL/2);
        make.top.mas_equalTo(self.rightLabel.mas_bottom);
        make.right.mas_equalTo(self.mas_right).offset(-DEFAULT_INTERVAL/2);
        make.height.mas_equalTo(30);
    }];
    
    [self layoutIfNeeded];
}

//计算headerview的高度
- (CGFloat)getViewHeight {
    return self.nLabel.bottom;
}
- (void)tipBtnClick:(UIButton *)sender {
    GSLablsModel *model = self.lablsArray[sender.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tipBtnClick:)]) {
        [self.delegate tipBtnClick:model];
    }
}
@end
