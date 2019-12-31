//
//  GSSearchCell.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/18.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSSearchCell.h"

@interface GSSearchCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation GSSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.imgView = [[UIImageView alloc] init];
        self.imgView.userInteractionEnabled = YES;
        self.imgView.layer.cornerRadius = 10;
        self.imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(DEFAULT_INTERVAL/2);
            make.width.mas_equalTo(SCREEN_WIDTH - DEFAULT_INTERVAL);
            make.top.mas_equalTo(self).offset(DEFAULT_INTERVAL / 2);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.alpha = 0.5;
        self.titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.imgView);
            make.top.mas_equalTo(self.imgView.mas_top);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)setModel:(GSSearchListModel *)model {
    self.titleLabel.text = [GSTools stringEncoding:model.title];
    if (!MAIN_TEST) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.coverpath] placeholderImage:[UIImage imageNamed:@"dahuan"]];
    } else {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.coverpath1] placeholderImage:[UIImage imageNamed:@"dahuan"]];
    }
}

@end
