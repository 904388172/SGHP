//
//  GSMainCommonCell.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/11.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSMainCommonCell.h"
#import "GSVideoModel.h"
#import "GSMayLikeModel.h"
#import "GSTapGestureRecognizer.h"

@interface GSMainCommonCell()

@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *rightView;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) GSTapGestureRecognizer *leftTap;
@property (nonatomic, strong) GSTapGestureRecognizer *rightTap;

@end

@implementation GSMainCommonCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.leftView = [[UIImageView alloc] init];
        self.leftView.userInteractionEnabled = YES;
        self.leftTap = [[GSTapGestureRecognizer alloc] initWithTarget:self action:@selector(didCommonCell:)];
        [self.leftView addGestureRecognizer:self.leftTap];
        [self.contentView addSubview:self.leftView];
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(DEFAULT_INTERVAL/2);
            make.width.mas_equalTo(SCREEN_WIDTH/2 - DEFAULT_INTERVAL);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-25);
        }];
    
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        self.leftLabel = leftLabel;
        [self.contentView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.leftView);
            make.top.mas_equalTo(self.leftView.mas_bottom);
            make.height.mas_equalTo(25);
        }];
    
        self.rightView = [[UIImageView alloc] init];
        self.rightView.userInteractionEnabled = YES;
        self.rightTap = [[GSTapGestureRecognizer alloc] initWithTarget:self action:@selector(didCommonCell:)];
        [self.rightView addGestureRecognizer:self.rightTap];
        [self.contentView addSubview:self.rightView];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(SCREEN_WIDTH/2+DEFAULT_INTERVAL/2);
            make.trailing.mas_equalTo(self).offset(-DEFAULT_INTERVAL/2);
            make.top.mas_equalTo(self);
             make.bottom.mas_equalTo(self.mas_bottom).offset(-25);
        }];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.font = [UIFont systemFontOfSize:14];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        self.rightLabel = rightLabel;
        [self.contentView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.rightView);
            make.top.mas_equalTo(self.rightView.mas_bottom);
            make.height.mas_equalTo(25);
        }];
    }
    return self;
}

- (void)setCellLeftModel:(GSMainModel *)cellLeftModel {
    
    if ([cellLeftModel isKindOfClass:[GSMayLikeModel class]]) {
        GSMayLikeModel *model = (GSMayLikeModel *)cellLeftModel;
        self.leftLabel.text = [GSTools stringEncoding:model.title];
        if (!MAIN_TEST) {
            [self.leftView sd_setImageWithURL:[NSURL URLWithString:model.coverpath] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        } else {
            [self.leftView sd_setImageWithURL:[NSURL URLWithString:model.coverpath1] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        }
    } else {
        GSVideoModel *model = (GSVideoModel *)cellLeftModel;
        self.leftLabel.text = [GSTools stringEncoding:model.title];
        if (!MAIN_TEST) {
             [self.leftView sd_setImageWithURL:[NSURL URLWithString:model.coverpath] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        } else {
            [self.leftView sd_setImageWithURL:[NSURL URLWithString:model.coverpath1] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        }
    }
    self.leftTap.cellModel = cellLeftModel;
}

- (void)setCellRightModel:(GSMainModel *)cellRightModel {
    
    if ([cellRightModel isKindOfClass:[GSMayLikeModel class]]) {
        GSMayLikeModel *model = (GSMayLikeModel *)cellRightModel;
        self.rightLabel.text = [GSTools stringEncoding:model.title];
        if (!MAIN_TEST) {
            [self.rightView sd_setImageWithURL:[NSURL URLWithString:model.coverpath] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        } else {
            [self.rightView sd_setImageWithURL:[NSURL URLWithString:model.coverpath1] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        }
    } else {
        GSVideoModel *model = (GSVideoModel *)cellRightModel;
         self.rightLabel.text = [GSTools stringEncoding:model.title];
        if (!MAIN_TEST) {
            [self.rightView sd_setImageWithURL:[NSURL URLWithString:model.coverpath] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        } else {
            [self.rightView sd_setImageWithURL:[NSURL URLWithString:model.coverpath1] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        }
    }
    self.rightTap.cellModel = cellRightModel;
}

//点击图片
- (void)didCommonCell:(GSTapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainCommonCell:didSelectModel:)]) {
        [self.delegate mainCommonCell:self didSelectModel:tap.cellModel];
    }
}

@end
