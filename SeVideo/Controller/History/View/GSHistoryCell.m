//
//  GSHistoryCell.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/27.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSHistoryCell.h"

static float cellHeight = 120;
@interface GSHistoryCell ()

@property (nonatomic, strong) UIButton *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UILabel *updateLabel;

@end

@implementation GSHistoryCell

- (UIButton *)iconView {
    if (!_iconView) {
        _iconView = [[UIButton alloc] init];
    }
    return _iconView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [GSTools returnTextColor];
    }
    return _titleLabel;
}
- (UIView *)btnView {
    if (!_btnView) {
        _btnView = [[UIView alloc] init];
    }
    return _btnView;
}
- (UILabel *)updateLabel {
    if (!_updateLabel) {
        _updateLabel = [[UILabel alloc] init];
        _updateLabel.font = [UIFont boldSystemFontOfSize:14];
        _updateLabel.textColor = [GSTools returnDetailColor];
    }
    return _updateLabel;
}

- (void)setModel:(GSDetailModel *)model {
    if (!MAIN_TEST) {
//        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.coverpath] placeholderImage:[UIImage imageNamed:@"dahuan"]];
//        [self.iconView setImage:[UIImage imageNamed:@"search-img"] forState:UIControlStateNormal];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.coverpath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"dahuan"]];
    } else {
//        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.coverpath1] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.coverpath1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"dahuan"]];
    }
    self.titleLabel.text = [GSTools stringEncoding:model.title];
    self.updateLabel.text = [NSString stringWithFormat:@"%@%@%ld%@",[model.updated_at substringToIndex:10],@" 播放",model.pageviews / 10000,@"万次"];;
    
    float marginLeft = 0;
    float marginTop = 0;
    for (UIButton *btn in self.btnView.subviews) {
        [btn removeFromSuperview];
    }
    for (int i = 0; i < model.labls.count; i++) {
        GSLablsModel *lModel = model.labls[i];
        float sizeWidth = [lModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size.width + DEFAULT_INTERVAL/2;
        
        UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipBtn setTitle:[GSTools stringEncoding:lModel.name] forState:UIControlStateNormal];
        [tipBtn setTitleColor:[GSTools returnDetailColor] forState:UIControlStateNormal];
        tipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        tipBtn.backgroundColor = RGB(220, 220, 220);
        tipBtn.layer.cornerRadius = 6;
        tipBtn.layer.borderWidth = 1;
        tipBtn.layer.borderColor = RGB(220, 220, 220).CGColor;
        tipBtn.tag = i;
        [self.btnView addSubview:tipBtn];
        
        if (marginLeft + sizeWidth + DEFAULT_INTERVAL/2 > SCREEN_WIDTH - cellHeight*4/3 - DEFAULT_INTERVAL*1.5) {
            marginTop = 28;
            marginLeft = 0;
        }
        [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.btnView.mas_left).offset(marginLeft);
            make.top.mas_equalTo(self.btnView.mas_top).offset(marginTop);
            make.width.mas_equalTo(sizeWidth);
            make.height.mas_equalTo(22);
        }];
        marginLeft += sizeWidth+DEFAULT_INTERVAL/2;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpCell];
        
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(DEFAULT_INTERVAL/2);
            make.top.mas_equalTo(self).offset(DEFAULT_INTERVAL/2);
            make.height.mas_equalTo(cellHeight - DEFAULT_INTERVAL);
            make.width.mas_equalTo(cellHeight*4/3);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconView.mas_right).offset(DEFAULT_INTERVAL/2);
            make.top.mas_equalTo(self.iconView.mas_top);
            make.height.mas_equalTo(26);
            make.right.mas_equalTo(self.mas_right).offset(-DEFAULT_INTERVAL/2);
        }];
        
        [self addSubview:self.updateLabel];
        [self.updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.bottom.mas_equalTo(self.iconView.mas_bottom);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.titleLabel.mas_right);
        }];
        
        [self addSubview:self.btnView];
        [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.bottom.mas_equalTo(self.updateLabel.mas_top);
            make.right.mas_equalTo(self.titleLabel.mas_right);
        }];
        
    }
    return self;
}

- (void)setUpCell {
    //去除选中时cell的蓝色背景
    UIView *backGroundView = [[UIView alloc] init];
    backGroundView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = backGroundView;
    
   
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    //重写此方法，作用为当进入编辑模式时候运行customMultipleChioce方法
    [super setEditing:editing animated:animated];
    if (editing) {
        [self customMultipleChioce];
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
        }];
    } else {
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(DEFAULT_INTERVAL/2);
        }];
    }
}

- (void)layoutSubviews {
    [self customMultipleChioce];
    [super layoutSubviews];
}

- (void)customMultipleChioce {
    for (UIControl *control in self.subviews) {
        //循环cell的subview
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
            //找出UITableViewCellEditControl
            for (UIView *view in control.subviews) {
                if ([view isKindOfClass: [UIImageView class]]) {
                    //在UITableViewCellEditControl中找到imageView
                    UIImageView *imageView = (UIImageView *)view;
                    if (self.selected) {
                        imageView.image = [UIImage imageNamed:@"selected"];
                    }else {
                        imageView.image = [UIImage imageNamed:@"unselected"];
                    }
                }
            }
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
