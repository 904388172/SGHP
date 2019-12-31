//
//  GSSearchViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSSearchViewController.h"
#import "GSSearchHandler.h"
#import "GSSearchHotView.h"
#import "GSSearchListModel.h"
#import "GSSearchCell.h"
#import "GSPlayViewController.h"

@interface GSSearchViewController () <UITextFieldDelegate,GSDidTapsDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIView *searchHotView;

@property (nonatomic, strong) NSMutableArray *hotArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *searchKey;

@property (nonatomic, assign) NSInteger searchIndex;

@end

@implementation GSSearchViewController

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
- (NSMutableArray *)hotArray {
    if (!_hotArray) {
        _hotArray = [[NSMutableArray alloc] init];
    }
    return _hotArray;
}
- (UIView *)searchHotView {
    if (!_searchHotView) {
        _searchHotView = [[UIView alloc] init];
    }
    return _searchHotView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchIndex = 0;
    
    [self initUI];
    
    [self getSearchHot];
    
}
/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewBills)];
    
    // 马上进入刷新状态
//    [self.tableView.mj_header beginRefreshing];
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
    _searchIndex = 0;//默认加载第一页
    //获取列表
    [self searchKey:self.searchKey];
}
/**
 *  加载上拉加载数据
 */
-(void)loadMoreBills
{
    //1.设置页数
    _searchIndex++;//默认加载第二页
    //获取列表
    [self searchKey:self.searchKey];
}
#pragma mark ================ tableView delegate ===================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GSSearchListModel *model = self.dataArray[indexPath.row];
    GSPlayViewController *vc = [[GSPlayViewController alloc] init];
    vc.playID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- 刷新热搜标签
- (void)refreshSearchHotView {
    NSMutableArray *contentArr = [[NSMutableArray alloc] init];
    NSMutableArray *titleArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.hotArray.count; i++) {
        [titleArr addObject:self.hotArray[i][@"title"]];
        [contentArr addObject:self.hotArray[i][@"lists"]];
    }
    
    GSSearchHotView *silde = [[GSSearchHotView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    silde.delegate = self;
    silde.radius = 10;
    silde.font = [UIFont systemFontOfSize:14];
    silde.titleTextFont = [UIFont systemFontOfSize:18];
    [silde setContentView:contentArr titleArr:titleArr];
    [self.searchHotView addSubview:silde];
}
#pragma mark --- 点击tag
- (void)gs_selectCurrentValueWith:(NSString *)value index:(NSInteger)index groupId:(NSInteger)groupId {
    self.searchIndex = 0;
    self.searchKey = value;
    self.searchBar.text = self.searchKey;
    [self searchKey:self.searchKey];
}
#pragma mark ================ 搜索 ===================
- (void)searchKey:(NSString *)key {
    if (self.searchIndex == 0) {
        self.searchHotView.hidden = YES;
        self.tableView.hidden = NO;
    }
    
    [GSSearchHandler searchKey:key withIndex:self.searchIndex Success:^(id  _Nonnull obj) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic = obj[@"rescont"];
        
        NSMutableArray *data = [NSMutableArray arrayWithArray:dic[@"data"]];
        if (self.searchIndex == 0) {
            [self.dataArray removeAllObjects];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_header endRefreshing];
        } else {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
        if (data.count == 0 && self.searchIndex != 0) {
            //获得了所有数据
            self.searchIndex --;
            return;
        } else if (data.count == 0 && self.searchIndex == 0) {
            //该字段没有数据
            [HintView showInCurrentViewWithMessage:@"没有搜索到相关影片"];
            self.searchHotView.hidden = NO;
            self.tableView.hidden = YES;
            return;
        }
        
        for (int i = 0 ; i < data.count; i++) {
            GSSearchListModel *model = [[GSSearchListModel alloc] mj_setKeyValues:data[i]];
            [self.dataArray addObject: model];
        }
        [self.tableView reloadData];
    } failed:^(id  _Nonnull obj) {
        [HintView showInCurrentViewWithMessage:@"getVideoExplorePage---失败"];
        if (self.searchIndex == 0) {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_header endRefreshing];
        } else {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
//获取默认字段
- (void)getSearchHot {
    [GSSearchHandler getSearchHotSuccess:^(id  _Nonnull obj) {
        
        self.hotArray = obj[@"rescont"];
        [self refreshSearchHotView];
        
    } failed:^(id  _Nonnull obj) {
        [HintView showInCurrentViewWithMessage:@"getVideoExplorePage---失败"];
    }];
}
//搜索
- (void)searchButton:(UIButton *)sender {
    self.searchIndex = 0;
    if (![self.searchBar.text isEqualToString:@""]) {
        self.searchKey = self.searchBar.text;
        [self searchKey:self.searchKey];
    } else {
        self.searchHotView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

- (void)initUI {
    self.searchHotView.hidden = NO;
    [self.view addSubview:self.searchHotView];
    [self.searchHotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.bottom.mas_equalTo(self.view);
    }];
    
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.bottom.mas_equalTo(self.view);
    }];
    
    [self initNavView];
    
}
- (void)initNavView {
    
    UIView*titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH-160,40)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 160, 40)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.layer.cornerRadius = 20;
    self.searchBar.layer.masksToBounds = YES;
    //设置背景图是为了去掉上下黑线
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    //设置背景色
    self.searchBar.backgroundColor = [UIColor whiteColor];
    // 修改cancel
    self.searchBar.showsCancelButton=NO;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    //self.searchBar.searchBarStyle = UISearchBarStyleMinimal;//没有背影，透明样式
    self.searchBar.delegate=self;
    // 修改cancel
    self.searchBar.showsSearchResultsButton=NO;
    //5. 设置搜索Icon
    [self.searchBar setImage:[UIImage imageNamed:@"Search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    /*这段代码有个特别的地方就是通过KVC获得到UISearchBar的私有变量
     searchField（类型为UITextField），设置SearchBar的边框颜色和圆角实际上也就变成了设置searchField的边框颜色和圆角，你可以试试直接设置SearchBar.layer.borderColor和cornerRadius，会发现这样做是有问题的。*/
    
    //一下代码为修改placeholder字体的颜色和大小
    UITextField*searchField = [_searchBar valueForKey:@"_searchField"];
    //2. 设置圆角和边框颜色
    if(searchField) {
        [searchField setBackgroundColor:[UIColor clearColor]];
        // 根据@"_placeholderLabel.textColor" 找到placeholder的字体颜色
        [searchField setValue:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    }
    // 输入文本颜色
    searchField.textColor= [GSTools returnTextColor];
    searchField.font= [UIFont systemFontOfSize:15];
    // 默认文本大小
    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    //只有编辑时出现出现那个叉叉
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [titleView addSubview:self.searchBar];
    //Set to titleView
    self.navigationItem.titleView = titleView;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(0, 0, 60, 44);
    [searchButton addTarget:self action:@selector(searchButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
}


@end
