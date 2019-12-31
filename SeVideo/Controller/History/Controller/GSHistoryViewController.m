//
//  GSHistoryViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/27.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSHistoryViewController.h"
#import "GSHistoryHandler.h"
#import "GSHistoryCell.h"
#import "GSDetailModel.h"

@interface GSHistoryViewController () <UITableViewDelegate,UITableViewDataSource> {
    BOOL deleteAll;
}

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) UIButton *allBtn;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UILabel *lookLabel;

@end

@implementation GSHistoryViewController

- (UILabel *)lookLabel {
    if (!_lookLabel) {
        _lookLabel = [[UILabel alloc] init];
        _lookLabel.font = [UIFont boldSystemFontOfSize:16];
        _lookLabel.textColor = [GSTools returnTextColor];
        _lookLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lookLabel;
}
- (UIButton *)allBtn {
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _allBtn;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _deleteBtn;
}
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //此处写入让其不显示下划线的代码
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //集成下拉刷新控件
//        [self setupDownRefresh];
//
//        //集成上拉刷新控件
//        [self setupUpRefresh];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex = 1;
    deleteAll = false;
    
    [self initUI];
    
    //获取列表
    [self getHistoryList];
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
    [self getHistoryList];
}
/**
 *  加载上拉加载数据
 */
-(void)loadMoreBills
{
    //1.设置页数
    _pageIndex++;//默认加载第二页
    //获取列表
//    [self getHistoryList];
}

#pragma mark ================ tableView delegate ===================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 120;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellId";
    
    GSHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GSHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GSDetailModel *model = self.dataArray[indexPath.row];
    [self.selectArray addObject:model];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    GSDetailModel *model = self.dataArray[indexPath.row];
    [self.selectArray removeObject:model];
}

//删除历史记录
- (void)deleteHistory {
    NSString *deleteId = @"all";
    if (!deleteAll) {
        GSDetailModel *deleteModel = self.selectArray[0];
        deleteId = [NSString stringWithFormat:@"%ld",deleteModel.ID];
    }
    [GSHistoryHandler deleteHistory:deleteId Success:^(id  _Nonnull obj) {
        NSLog(@"ddd");
    } failed:^(id  _Nonnull obj) {
        NSLog(@"ddd");
    }];
}

//获取历史列表
- (void)getHistoryList {
    [GSHistoryHandler getHistoryList:self.pageIndex Success:^(id  _Nonnull obj) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic = obj[@"rescont"];
        NSMutableArray *data = [NSMutableArray arrayWithArray:dic[@"data"]];
        
//        if (self.pageIndex == 1) {
//            [self.dataArray removeAllObjects];
//            // 拿到当前的下拉刷新控件，结束刷新状态
//            [self.tableView.mj_header endRefreshing];
//        } else {
//            // 拿到当前的下拉刷新控件，结束刷新状态
//            [self.tableView.mj_footer endRefreshing];
//        }
        
        if (data.count == 0) {
            self.allBtn.hidden = YES;
            self.deleteBtn.hidden = YES;
            self.lookLabel.hidden = NO;
            self.tableView.hidden = YES;
        } else {
            self.allBtn.hidden = YES;
            self.deleteBtn.hidden = YES;
            self.lookLabel.hidden = YES;
            self.tableView.hidden = NO;
        }
        
        for (int i = 0 ; i < data.count; i++) {
            GSDetailModel *model = [[GSDetailModel alloc] mj_setKeyValues:data[i]];
            [self.dataArray addObject: model];
        }
        [self.tableView reloadData];
    } failed:^(id  _Nonnull obj) {
        NSLog(@"ddd");
    }];
}

- (void)initUI {
    
    [self.allBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.allBtn setTitleColor:[GSTools returnTextColor] forState:UIControlStateNormal];
    self.allBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.allBtn.backgroundColor = [UIColor whiteColor];
    self.allBtn.layer.borderWidth = 1;
    self.allBtn.hidden = YES;
    self.allBtn.layer.borderColor = RGB(255, 105, 180).CGColor;
    [self.view addSubview:self.allBtn];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [self.allBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteBtn.hidden = YES;
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.deleteBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.allBtn.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.bottom.mas_equalTo(self.allBtn.mas_bottom);
        make.height.mas_equalTo(self.allBtn.mas_height);
    }];
    [self.deleteBtn addTarget:self action:@selector(deleteSelectedData) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.allBtn.mas_top);
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.lookLabel.hidden = NO;
    self.lookLabel.text = @"没有查到观看记录";
    [self.view addSubview:self.lookLabel];
    [self.lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(30);
    }];
}
//编辑
- (void)edit:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"编辑"]) {
        item.title = @"取消";
        self.allBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
        [self.allBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
        }];
        [self.tableView setEditing:YES animated:YES];
        
    }else {
        item.title = @"编辑";
        self.allBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
        [self.allBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.tableView setEditing:NO animated:YES];
        [self.selectArray removeAllObjects];
    }
}

//全选
- (void)selectAll:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        [sender setTitle:@"取消全选" forState:UIControlStateNormal];
        deleteAll = true;
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            GSDetailModel *model = self.dataArray[i];
            [self.selectArray addObject:model];
        }
    }else {
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        deleteAll = false;
        [self.selectArray removeAllObjects];
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            
        }
    }
}

//删除
- (void)deleteSelectedData {
    [HintView showInCurrentViewWithMessage:@"暂时有问题"];
    return;
    
    for (GSDetailModel *model in self.selectArray) {
        [self.dataArray removeObject:model];
    }
    [self.tableView reloadData];
//    删除接口
    [self deleteHistory];
}
@end
