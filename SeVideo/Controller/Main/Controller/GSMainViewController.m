//
//  GSMainViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/11/8.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSMainViewController.h"
#import "GSMainHandler.h"
#import "GSMainListModel.h"
#import "BtnView.h"
#import "GSBtnModel.h"
#import "GSAdvModel.h"
#import "GSMayLikeModel.h"
#import "GSMainCommonCell.h"
#import "GSTapGestureRecognizer.h"
#import "GSCategoryViewController.h"
#import "GSPlayViewController.h"
#import "GSHistoryViewController.h"



@interface GSMainViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,BtnViewDidSelected,MainCommonCellDelegate> {
    CGFloat scrollHeight;
    CGFloat btnViewHeight;
}

//第一个section的header
@property (nonatomic, strong) UIView *headerView;
//轮播
@property (nonatomic, strong) UIScrollView *topScrolView;
//轮播数据
@property (nonatomic, strong) NSMutableArray *scrollData;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;


//按钮
@property (nonatomic, strong) BtnView *btnView;
//按钮
@property (nonatomic, strong) NSMutableArray *itemsArray;

//推荐table
@property (nonatomic, strong) UITableView *firstTable;

@property (nonatomic, strong) NSMutableArray *firstDataArray;
@property (nonatomic, strong) NSMutableArray *secondDataArray;

@property (nonatomic, assign) NSInteger queryNum;
@property (nonatomic, assign) NSInteger cellHeight;
@end

@implementation GSMainViewController

- (UITableView *)firstTable {
    if (!_firstTable) {
        _firstTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _firstTable.delegate = self;
        _firstTable.dataSource = self;
        //此处写入让其不显示下划线的代码
        _firstTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _firstTable;
}
- (BtnView *)btnView {
    if (!_btnView) {
        _btnView = [[BtnView alloc] initWithFrame:CGRectMake(0, self.topScrolView.height, SCREEN_WIDTH, btnViewHeight+DEFAULT_INTERVAL/2)];
        _btnView.delegate = self;
        _btnView.userInteractionEnabled = YES;
    }
    return _btnView;
}
- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [[NSMutableArray alloc] init];
    }
    return _itemsArray;
}
- (UIScrollView *)topScrolView {

    if (!_topScrolView) {
        _topScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollHeight)];
        _topScrolView.delegate = self;
        //设置scrollview的content
        _topScrolView.contentSize = CGSizeMake(SCREEN_WIDTH*4, 0);
        //整页滑动
        _topScrolView.pagingEnabled = YES;
        //可弹性
        _topScrolView.bounces = NO;
        _topScrolView.showsHorizontalScrollIndicator = NO;
        _topScrolView.showsVerticalScrollIndicator = NO;
    }
    return _topScrolView;
}

- (NSMutableArray *)scrollData {
    if (!_scrollData) {
        _scrollData = [[NSMutableArray alloc] init];
    }
    return _scrollData;
}
- (NSMutableArray *)firstDataArray {
    if (!_firstDataArray) {
        _firstDataArray = [[NSMutableArray alloc] init];
    }
    return _firstDataArray;
}
- (NSMutableArray *)secondDataArray {
    if (!_secondDataArray) {
        _secondDataArray = [[NSMutableArray alloc] init];
    }
    return _secondDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    scrollHeight = 150;
    btnViewHeight = (SCREEN_WIDTH - DEFAULT_INTERVAL*5) / 4 * 2 + 50;
    self.cellHeight = 150;
    self.queryNum = 2;
    [self setUpUI];
    
    
//    [self testData];
    //获取轮播数据
    [self getScrollList];
    //获取按钮列表
    [self getBtnList];
    //获取列表
    [self getMainList];
    //获取推荐列表
    [self getMayLikeList];
}
#pragma mark ================ 测试接口 ===================
- (void)testData {
//    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://sg01.sg01.sg01.xyz//api/userseen?",[[GSUserDefaultStatus sharedManager] returnUUID]];
    NSString *url = @"http://sg01.sg01.sg01.xyz//api/userseen?uuid=28457D83-2624-4A66-BDDC-F692D0213C23&device=1&page=1";
    [GSMainHandler testUrl:url success:^(id  _Nonnull obj) {
        NSLog(@"ddd");
    } failed:^(id  _Nonnull obj) {
        NSLog(@"ddd");
    }];
}

#pragma mark ================ tableview delegate ===================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.firstDataArray.count != 0 && self.secondDataArray.count != 0) {
        return self.secondDataArray.count + 1;
    } else {
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.firstDataArray.count / 2;
    } else {
        if (self.secondDataArray.count != 0) {
            GSMainListModel *model = self.secondDataArray[0];
            return model.list.count/2;
            
        } else {
            return 0;
        }
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [GSTools returnTextColor];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(DEFAULT_INTERVAL/2);
        make.top.bottom.mas_equalTo(headerView);
    }];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"更多 " forState:UIControlStateNormal];
    [moreBtn setTitleColor:[GSTools returnTextColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [moreBtn setImage:[UIImage imageNamed:@"global_back"] forState:UIControlStateNormal];
    [headerView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerView.mas_right).offset(-DEFAULT_INTERVAL/2);
        make.top.bottom.mas_equalTo(headerView);
        make.width.mas_equalTo(80);
    }];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - moreBtn.imageView.image.size.width, 0, moreBtn.imageView.image.size.width)];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, moreBtn.titleLabel.bounds.size.width, 0, -moreBtn.titleLabel.bounds.size.width-DEFAULT_INTERVAL)];
    
    if (section == 0) {
        titleLabel.text = @"可能喜欢";
    } else {
        GSMainListModel *model = self.secondDataArray[section-1];
        titleLabel.text = model.name;
    }
    moreBtn.tag = section;
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellId";
    GSMainCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GSMainCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.cellLeftModel = self.firstDataArray[indexPath.row*2];
        cell.cellRightModel = self.firstDataArray[indexPath.row*2+1];
    } else {
        GSMainListModel *model = self.secondDataArray[indexPath.section - 1];
        NSArray *arr = model.list;
        cell.cellLeftModel = arr[indexPath.row*2];
        cell.cellRightModel = arr[indexPath.row*2+1];
    }
    
    cell.delegate = self;

    return cell;
}

#pragma mark ================ 创建scrollview ===================
- (void)createScrollView {
    
    [self addTimer];
    
    // 添加图片
    for (int i = 0; i < self.scrollData.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        GSAdvModel *model = self.scrollData[i];
        // 设置frame
        imageView.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollHeight);
        imageView.backgroundColor = [UIColor greenColor];
        // 设置图片
        if (MAIN_TEST) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgpatch] placeholderImage:[UIImage imageNamed:@"dahuan"]];
        } else {
            if ([[[GSUserDefaultStatus sharedManager] returnRoleStatus] isEqualToString:@"1"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgpatch] placeholderImage:[UIImage imageNamed:@"dahuan"]];
            } else if ([[[GSUserDefaultStatus sharedManager] returnRoleStatus] isEqualToString:@"2"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgpatch] placeholderImage:[UIImage imageNamed:@"dahuan"]];
            } else {
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgpatch] placeholderImage:[UIImage imageNamed:@"dahuan"]];
            }
        }

        // 隐藏指示条
        self.topScrolView.showsHorizontalScrollIndicator = NO;
        imageView.userInteractionEnabled = YES;

        [self.topScrolView addSubview:imageView];

        GSTapGestureRecognizer *tap = [[GSTapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        tap.advModel = model;
        [imageView addGestureRecognizer:tap];
    }

    //这里frame我是随便写的，真正的去经过计算
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.topScrolView.height - 50, self.topScrolView.width, 50)];
    self.pageControl = pageControl;
    self.pageControl.numberOfPages = self.scrollData.count;//指定页面个数
    self.pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    //添加委托方法，当点击小白点就执行此方法
    //...
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];// 设置非选中页的圆点颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    //注意是self.view
    [self.view addSubview:self.pageControl];
}
//不要忘记 UIScrollViewDelegate
//ScrollView滑动结束的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 计算页码
    // 页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) / scrollviewW;
    self.pageControl.currentPage = page;
}
// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
}
/**
 * 开启定时器
 */
- (void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
- (void)nextImage
{
    int page = (int)self.pageControl.currentPage;
    if (page == self.scrollData.count - 1) {
        page = 0;
    } else {
        page++;
    }
    // 滚动scrollview
    CGFloat x = page * self.topScrolView.width;
    [self.topScrolView setContentOffset:CGPointMake(x, 0) animated:YES];
}
/**
 * 关闭定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
}
- (void)clickImage:(GSTapGestureRecognizer *)tap {
//    [self getData:tap.scrollModel];
    NSLog(@"ssss");
    
}
- (void)historyButton:(UIButton *)sender {
    GSHistoryViewController *vc = [[GSHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ================ 初始化页面 ===================
- (void)setUpUI {
    //设置按钮
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyButton setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
    historyButton.frame = CGRectMake(0, 0, 44, 44);
    [historyButton addTarget:self action:@selector(historyButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:historyButton];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollHeight+btnViewHeight+DEFAULT_INTERVAL/2)];
    [self.view addSubview:self.headerView];
    //添加轮播
    [self.headerView addSubview:self.topScrolView];
    //添加按钮
    [self.headerView addSubview:self.btnView];
    
    //添加table
    [self.view addSubview:self.firstTable];
    [self.firstTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

}
#pragma mark ================ 获取数据 ===================
//轮播列表
- (void)getScrollList {
    [GSMainHandler getAdInfoSuccess:^(id  _Nonnull obj) {
        NSMutableArray *data = [NSMutableArray arrayWithArray:obj[@"rescont"]];
        
        for (int i = 0 ; i < data.count; i++) {
            GSAdvModel *model = [[GSAdvModel alloc] mj_setKeyValues:data[i]];
            [self.scrollData addObject: model];
        }

        [self createScrollView];
        
    } failed:^(id  _Nonnull obj) {
        NSLog(@"ddd");
    }];
}
// 按钮列表
- (void)getBtnList {
    [GSMainHandler getSortListSuccess:^(id  _Nonnull obj) {
        NSMutableArray *data = [NSMutableArray arrayWithArray:obj[@"rescont"]];
        
        for (int i = 0 ; i < data.count; i++) {
            GSBtnModel *model = [[GSBtnModel alloc] mj_setKeyValues:data[i]];
            [self.itemsArray addObject: model];
        }
        self.btnView.btnItems = [self.itemsArray subarrayWithRange:NSMakeRange(0, 7)];
        
    } failed:^(id  _Nonnull obj) {
        NSLog(@"ddd");
    }];
}
- (void)reloadTableView {
    if (self.queryNum == 0) {
        [self.firstTable reloadData];
    }
}
//推荐列表
- (void)getMayLikeList {
    [GSMainHandler getMayLike:20 success:^(id  _Nonnull obj) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic = obj[@"rescont"];
        
        NSMutableArray *data = [NSMutableArray arrayWithArray:dic[@"data"]];
        
        for (int i = 0 ; i < data.count; i++) {
            GSMayLikeModel *model = [[GSMayLikeModel alloc] mj_setKeyValues:data[i]];
            [self.firstDataArray addObject: model];
        }
        self.queryNum --;
        [self reloadTableView];
    } failed:^(id  _Nonnull obj) {
        [HintView showInCurrentViewWithMessage:@"getMainIndexSuccess---失败"];
    }];
}
//其他列表
- (void)getMainList {
    
    [GSMainHandler getMainDataSuccess:^(id  _Nonnull obj) {
        NSMutableArray *data = [NSMutableArray arrayWithArray:obj[@"rescont"]];
       
        for (int i = 0 ; i < data.count; i++) {            
            GSMainListModel *model = [[GSMainListModel alloc] mj_setKeyValues:data[i]];
            if (model.is_ad == 0) { //非广告
                [self.secondDataArray addObject: model];
            }
        }
        self.queryNum --;
        [self reloadTableView];
    } failed:^(id  _Nonnull obj) {
        [HintView showInCurrentViewWithMessage:@"getMainIndexSuccess---失败"];
    }];
}

#pragma mark ================ btnView的delegate ===================
- (void)btnViewDidSelected:(BtnView *)btnView withIndex:(NSInteger)index {
    GSCategoryViewController *vc = [[GSCategoryViewController alloc] init];
    if (index == 7) { //全部
        GSBtnModel *model = [[GSBtnModel alloc] init];
        model.ID = 0;
        model.name = @"全部";
        vc.btnModel = model;
    } else { //
        vc.btnModel = self.itemsArray[index];
    }    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ================ didcell delegate ===================
- (void)mainCommonCell:(GSMainCommonCell *)mainCommonCell didSelectModel:(nonnull id)model {
    NSLog(@"ddd");
    GSPlayViewController *vc = [[GSPlayViewController alloc] init];
    if ([model isKindOfClass:[GSVideoModel class]]) {
        GSVideoModel *m = (GSVideoModel *)model;
        vc.playID = m.ID;
    } else {
        GSMayLikeModel *m = (GSMayLikeModel *)model;
        vc.playID = m.ID;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreBtnClick:(UIButton *)sender {
    
    
    GSCategoryViewController *vc = [[GSCategoryViewController alloc] init];
    GSBtnModel *btnModel = [[GSBtnModel alloc] init];
    if (sender.tag == 0) {
        NSLog(@"推荐"); //可能喜欢
        btnModel.ID = 0;
        btnModel.name = @"全部";
    } else {
        GSMainListModel *model = [[GSMainListModel alloc] init];
        model = self.secondDataArray[sender.tag - 1];
        btnModel.ID = model.type_id;
        btnModel.order = model.type;
        btnModel.created_at = model.created_at;
        btnModel.deleted_at = model.deleted_at;
        btnModel.name = model.name;
        btnModel.icopath = model.imgpath;
    }
    vc.btnModel = btnModel;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
