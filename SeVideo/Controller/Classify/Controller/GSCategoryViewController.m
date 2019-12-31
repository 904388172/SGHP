//
//  GSCategoryViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/11/12.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSCategoryViewController.h"
#import "GSMenuView.h"
#import "GSMainHandler.h"
#import "GSCategoryHandler.h"
#import "GSSearchListModel.h"
#import "GSSearchCell.h"
#import "GSPlayViewController.h"


@interface GSCategoryViewController ()<GSTopMenuDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSArray *btnInfos;
    NSString *type;
     UILabel *label;
}

@property (nonatomic, strong) GSMenuView *menuView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GSCategoryViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //此处写入让其不显示下划线的代码
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //集成下拉刷新控件
        [self setupDownRefresh];
        
        //集成上拉刷新控件
        [self setupUpRefresh];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex = 1;
    btnInfos = @[@"",@"new",@"hot",@"like"];
    type = @"";
    [self initUI];
   
    
    [self getBtnList];
    
}
/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewBills)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBills)];
}
/**
 *  加载下拉刷新数据
 */
- (void)loadNewBills
{
    _pageIndex = 1;//默认加载第一页
    //获取列表
    [self getCategoryList:type];
}
/**
 *  加载上拉加载数据
 */
-(void)loadMoreBills
{
    //1.设置页数
    _pageIndex++;//默认加载第二页
    //获取列表
    [self getCategoryList:type];
}

#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellId";
    GSSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GSSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GSSearchListModel *model = self.dataArray[indexPath.row];
    GSPlayViewController *vc = [[GSPlayViewController alloc] init];
    vc.playID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getCategoryList:(NSString *)type {
    [GSCategoryHandler getCategoryList:type
                           withVideoId:self.btnModel.ID
                             withIndex:self.pageIndex
                               Success:^(id  _Nonnull obj) {
                                   NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                                   dic = obj[@"rescont"];
                                   NSMutableArray *data = [NSMutableArray arrayWithArray:dic[@"data"]];
                                   
                                   if (self.pageIndex == 1) {
                                       [self.dataArray removeAllObjects];
                                       // 拿到当前的下拉刷新控件，结束刷新状态
                                       [self.tableView.mj_header endRefreshing];
                                   } else {
                                       // 拿到当前的下拉刷新控件，结束刷新状态
                                       [self.tableView.mj_footer endRefreshing];
                                   }
                                   
                                   for (int i = 0 ; i < data.count; i++) {
                                        GSSearchListModel *model = [[GSSearchListModel alloc] mj_setKeyValues:data[i]];
                                        [self.dataArray addObject: model];
                                   }
                                   [self.tableView reloadData];
                                   
                               } failed:^(id  _Nonnull obj) {
                                   [HintView showInCurrentViewWithMessage:@"getVideoExplorePage---失败"];
                                   if (self.pageIndex == 1) {
                                       // 拿到当前的下拉刷新控件，结束刷新状态
                                       [self.tableView.mj_header endRefreshing];
                                   } else {
                                       // 拿到当前的下拉刷新控件，结束刷新状态
                                       [self.tableView.mj_footer endRefreshing];
                                   }
                               } ];
}
//按钮列表
- (void)getBtnList {
    [GSMainHandler getSortListSuccess:^(id  _Nonnull obj) {
        NSMutableArray *data = [NSMutableArray arrayWithArray:obj[@"rescont"]];
        
        GSBtnModel *firstModel = [[GSBtnModel alloc] init];
        firstModel.ID = 0;
        firstModel.name = @"全部";
        [self.btnArray addObject: firstModel];
        
        for (int i = 0 ; i < data.count; i++) {
            GSBtnModel *model = [[GSBtnModel alloc] mj_setKeyValues:data[i]];
            [self.btnArray addObject: model];
        }
        
        self.menuView.selectID = self.btnModel.ID;
        [self.menuView calcurateWidth:self.btnArray];

    } failed:^(id  _Nonnull obj) {
        NSLog(@"ddd");
    }];
}
#pragma mark ================ 菜单代理 ===================
- (void)selectTopMenu:(GSBtnModel *)model {
    self.pageIndex = 1;
    self.btnModel = model;
    //获取列表
    [self getCategoryList:type];
}
- (void)titleClick:(UIButton *)sender {
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *btn = self.titleArray[i];
        [btn setTitleColor:[GSTools returnTextColor] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    type = btnInfos[sender.tag];
    self.pageIndex = 1;
    
    //获取列表
    [self getCategoryList:type];
}

- (void)initUI {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [self.view addSubview:topView];
    NSArray *titleArr = @[@"全部",@"最新",@"最热",@"喜欢"];
    float btnW = 70;
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(DEFAULT_INTERVAL + btnW*i + DEFAULT_INTERVAL*i, DEFAULT_INTERVAL/2, btnW , 32);

        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        titleBtn.layer.cornerRadius = 8.0;
        titleBtn.layer.masksToBounds = YES;
        [titleBtn setTitleColor:[GSTools returnTextColor] forState:UIControlStateNormal];
        titleBtn.tag = i;
        titleBtn.backgroundColor = [GSTools returnMainUIColor];
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:titleBtn];
        if (i == 0) {
            titleBtn.selected = YES;
            [titleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        
        [self.titleArray addObject:titleBtn];
    }
    
    self.menuView = [[GSMenuView alloc] initWithFrame:CGRectMake(0, topView.height, SCREEN_WIDTH, 60)];
    self.menuView.topMenuDelegate = self;
    [self.view addSubview:self.menuView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.menuView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}

@end
