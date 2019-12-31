//
//  GSMenuView.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/18.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSMenuView.h"

#define kIntroMarginW 0
#define kViewCenterX self.center.x
#define kDefaultEdgeInsets UIEdgeInsetsMake(6, 12, 6, 12)

@interface GSMenuView() <UIScrollViewDelegate>
{
//    NSMutableArray *arr_Button;
}
@property (nonatomic, strong) NSMutableArray *arr_Button;

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation GSMenuView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self settingScroll];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self settingScroll];
    }
    
    return self;
}

-(void)settingScroll{
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = NO;
    self.bounces = YES;
    
    if(self.arr_Button == nil) {
        self.arr_Button = [[NSMutableArray alloc] init];
    }
}
- (CGFloat)widthForMenuTitle:(NSString *)title buttonEdgeInsets:(UIEdgeInsets)buttonEdgeInsets
{
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f]];
    return CGSizeMake(size.width + buttonEdgeInsets.left + buttonEdgeInsets.right, size.height + buttonEdgeInsets.top + buttonEdgeInsets.bottom).width;
}

- (void)calcurateWidth:(NSArray *)menuList
{
    [self calcurateWidth:menuList buttonEdgeInsets:kDefaultEdgeInsets];
}
-(void)calcurateWidth:(NSArray *)menuList buttonEdgeInsets:(UIEdgeInsets)buttonEdgeInsets{
    [self clearView];
    
    self.modelArray = [[NSMutableArray alloc] initWithArray:menuList];
    //按钮中间的间隔
    __block CGFloat cWidth = 0;
    //按钮的高度
    __block CGFloat btnH = 32;
    
    [menuList enumerateObjectsUsingBlock:^(GSBtnModel *model, NSUInteger idx, BOOL *stop) {
        
        NSString *tagTitle = [GSTools stringEncoding:model.name];
        // 按钮的宽度
        CGFloat buttonWidth = [self widthForMenuTitle:tagTitle buttonEdgeInsets:buttonEdgeInsets];
        
        cWidth += DEFAULT_INTERVAL;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(cWidth, DEFAULT_INTERVAL/2, buttonWidth, btnH);
        
        [button setTitle:tagTitle forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        button.backgroundColor = [GSTools returnMainUIColor];
        button.layer.cornerRadius = 8.0;//2.0是圆角的弧度，根据需求自己更改
        [button setTitleColor:[GSTools returnTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = idx;
        if (self.selectID == -1) {
            button.selected = (idx == 0);
        } else if (model.ID == self.selectID) {
            button.selected = YES;
        }
        
        
        [self addSubview:button];
        
        [self.arr_Button addObject:button];
        
        cWidth += buttonWidth + kIntroMarginW;
    }];
    
    self.contentSize = CGSizeMake(cWidth, self.frame.size.height);
}

-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)clearView
{
    [self.subviews enumerateObjectsUsingBlock:^(UIView *v, NSUInteger idx, BOOL *stop) {
        [v removeFromSuperview];
    }];
}

#pragma mark - Events

- (void)buttonPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    [self.arr_Button enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        // Button Selected
        obj.selected = (btn.tag == idx);
    }];
    
    CGFloat btnX = btn.frame.origin.x;
    CGFloat btnCenterX = btn.center.x;
    CGPoint scrollPoint;
    
    /* Setting Scroll Center Point */
    if(btnCenterX > kViewCenterX && self.contentSize.width + kViewCenterX - self.frame.size.width > btnCenterX){
        scrollPoint = CGPointMake(btnX - kViewCenterX + (btn.frame.size.width/2), 0.0f);
    }else if(self.contentSize.width + kViewCenterX - self.frame.size.width < btnCenterX){
        scrollPoint = CGPointMake(self.contentSize.width - self.bounds.size.width,0.0f);
    }else {
        scrollPoint = CGPointMake(0.0f,0.0f);
    }
    [self setContentOffset:scrollPoint animated:YES];
    
    /* Call Delegate */
    if(self.topMenuDelegate && [self.topMenuDelegate respondsToSelector:@selector(selectTopMenu:)]){
        
        GSBtnModel *model = self.modelArray[btn.tag];
        [self.topMenuDelegate selectTopMenu:model];
    }
}

//#pragma mark - Page Change
//-(void)setScrollPage:(NSInteger)page{
//    [self buttonPressed:arr_Button[page]];
//}

//- (NSMutableArray *)buttons {
//    if (!_buttons) {
//        _buttons = [[NSMutableArray alloc] init];
//    }
//    return _buttons;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//
//    }
//    return self;
//}

//- (void)setMenus:(NSMutableArray *)menus {
//    //需要导入YYKit
//    self.btnW = SCREEN_WIDTH / menus.count;
////    if (menus.count > 5) {
////        self.btnW = SCREEN_WIDTH / 5;
////    }
//    self.menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
//    self.menuScrollView.delegate = self;
//    self.menuScrollView.showsHorizontalScrollIndicator = NO;
//    //设置scrollview的content
//    self.menuScrollView.backgroundColor = [UIColor yellowColor];
//    self.menuScrollView.contentSize = CGSizeMake(self.btnW * menus.count, 0);
//    self.menuScrollView.pagingEnabled = NO;
//    [self addSubview:self.menuScrollView];
//    NSInteger lastWidth = 0;
//    NSInteger lastLeft = 0;
//
//    for (NSInteger i = 0; i < menus.count; i++) {
//        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGSize contentSize = [self sizeWidthWidth:menus[i] font:[UIFont systemFontOfSize:16] maxHeight:btnH];
//
//        lastLeft = lastLeft + DEFAULT_INTERVAL;
//        titleBtn.frame = CGRectMake(lastLeft, 5, contentSize.width + DEFAULT_INTERVAL , btnH);
//        lastWidth = contentSize.width + DEFAULT_INTERVAL;
//        lastLeft = lastLeft + lastWidth;
//
//        [self.buttons addObject:titleBtn];
//        //        GSClassifyModel *model = menus[i];
//        [titleBtn setTitle:menus[i] forState:UIControlStateNormal];
//        [titleBtn setBackgroundImage:[UIImage imageWithColor:[GSTools returnMainUIColor]] forState:UIControlStateSelected];
//        [titleBtn setTitleColor:[GSTools returnTextColor] forState:UIControlStateNormal];
//        titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        titleBtn.layer.cornerRadius = 4.0;
//        titleBtn.layer.borderColor = [GSTools returnMainUIColor].CGColor;
//        titleBtn.layer.borderWidth = 1.0f;//设置边框粗细
//        titleBtn.layer.masksToBounds = YES;
//        //        titleBtn.frame = CGRectMake(DEFAULT_INTERVAL/2 + (self.btnW-DEFAULT_INTERVAL) * i + DEFAULT_INTERVAL*i, DEFAULT_INTERVAL/2, self.btnW - DEFAULT_INTERVAL, btnH-DEFAULT_INTERVAL);
//        titleBtn.tag = i;
//        titleBtn.backgroundColor = [UIColor blueColor];
//
//        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.menuScrollView addSubview:titleBtn];
//
//        if (i == 0) {
//            titleBtn.selected = YES;
//            self.lastItem = titleBtn;
//        }
//    }
//}
//
//#pragma mark---根据指定文本,字体和最大高度计算尺寸
//- (CGSize)sizeWidthWidth:(NSString *)text font:(UIFont *)font maxHeight:(CGFloat)height{
//
//    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
//    attrDict[NSFontAttributeName] = font;
//    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
//    return size;
//}
//
//
//- (void)titleClick:(UIButton *)button {
//    //
//    //    if (self.delegate && [self.delegate respondsToSelector:@selector(selectMenuTopBtn:)]) {
//    //        [self.delegate selectMenuTopBtn:button.tag];
//    //    }
//
//    //选中改变
//    self.lastItem.selected = NO;
//    button.selected = YES;
//    self.lastItem = button;
//
//    //设置动画
//    [UIView animateWithDuration:0.2 animations:^{
//        //将button扩大1.2倍
//        button.transform = CGAffineTransformMakeScale(1.2, 1.2); // 宽高放大1.2倍
//    } completion:^(BOOL finished) {
//        //恢复原始状态
//        [UIView animateWithDuration:0.2 animations:^{
//            button.transform = CGAffineTransformIdentity;
//        }];
//    }];
//
//    [self scrolling:button];
//}
//
////滚动时调用
//- (void)scrolling:(UIButton *)btn {
//
//    NSInteger marginLeft = btn.origin.x + btn.size.width;
//    if (marginLeft  < SCREEN_WIDTH) {
//        return;
//    } else {
//        btn.frame = CGRectMake(SCREEN_WIDTH - btn.size.width - DEFAULT_INTERVAL, btn.origin.y, btn.size.width, btn.size.height);
//    }
//
//    //YYKit的方法，block防止强引用
////    @weakify(self);
////    [UIView animateWithDuration:0.5 animations:^{
////        //YYKit的方法
////        @strongify(self);
//////        if (idx < 3) {
//////            return;
//////        }
//////        self.menuScrollView.contentOffset = CGPointMake(self.btnW * (idx - 2), 0);
////    }];
//}

@end
