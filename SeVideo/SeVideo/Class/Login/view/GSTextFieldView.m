//
//  GSTextFieldView.m
//  SeVideo
//
//  Created by 耿双 on 2019/9/6.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSTextFieldView.h"

@interface GSTextFieldView ()

@property (nonatomic, strong) UILabel *textLabel;


@end

@implementation GSTextFieldView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat kLoginCellHeight = 50;
        
        //label
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [GSTools returnTextColor];
        self.textLabel.text = @"密码：";
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(DEFAULT_INTERVAL);
            make.height.mas_equalTo(kLoginCellHeight);
            make.width.mas_equalTo(70);
        }];
        
        self.texeField = [[UITextField alloc]init];
        [self.texeField setFont:[UIFont systemFontOfSize:16]];
        [self.texeField setTextColor:[GSTools returnTextColor]];
        self.texeField.clearButtonMode = UITextFieldViewModeAlways;
        [self addSubview:self.texeField];
        [self.texeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLabel.mas_right).offset(DEFAULT_INTERVAL);
            make.top.mas_equalTo(self.textLabel.mas_top);
            make.right.mas_equalTo(self.mas_right).offset(-DEFAULT_INTERVAL);
            make.height.mas_equalTo(self.textLabel.mas_height);
        }];
        
        UIView *lineView=[[UIView alloc] init];
        lineView.backgroundColor=[GSTools returnSeparateColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.textLabel.mas_bottom);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setTextName:(NSString *)textName {
    self.textLabel.text = [NSString stringWithFormat:@"%@:",textName];
    self.texeField.placeholder = [NSString stringWithFormat:@"请输入%@",textName];
}

@end
