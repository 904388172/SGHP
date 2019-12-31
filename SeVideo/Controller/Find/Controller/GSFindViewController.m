//
//  GSFindViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSFindViewController.h"
#import "GSFindHandler.h"
#import "GSExploreModel.h"
#import "GSExploreCell.h"
#import "GSSearchViewController.h"
#import "GSPlayViewController.h"

@interface GSFindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation GSFindViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.pageIndex = 1;
    
    [self initUI];
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
    [self getExploreData];
}
/**
 *  加载上拉加载数据
 */
-(void)loadMoreBills
{
    //1.设置页数
    _pageIndex++;//默认加载第二页
    //获取列表
    [self getExploreData];
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
    GSExploreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GSExploreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GSExploreModel *model = self.dataArray[indexPath.section];
    GSPlayViewController *vc = [[GSPlayViewController alloc] init];
    vc.playID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ================ 获取列表 ===================
- (void)getExploreData {
    [GSFindHandler getVideoExplorePage:self.pageIndex Success:^(id  _Nonnull obj) {
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
            if ([data[i][@"is_ad"] isEqualToNumber:@0]) {
                GSExploreModel *model = [[GSExploreModel alloc] mj_setKeyValues:data[i]];
                [self.dataArray addObject: model];
            }
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
    }];
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    //设置按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"search-img"] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(0, 0, 44, 44);
    [searchButton addTarget:self action:@selector(searchButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
}

#pragma mark ================ 搜索 ===================
- (void)searchButton:(UIButton *)sender {
    GSSearchViewController *vc = [[GSSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
