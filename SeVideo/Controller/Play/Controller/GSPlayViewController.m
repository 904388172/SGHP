//
//  GSPlayViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/12/17.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSPlayViewController.h"
#import "GSPlayHandler.h"
#import "GSDetailModel.h"
//播放器头文件 start
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <SJUIKit/NSAttributedString+SJMake.h>
//播放器头文件 end
#import "GSPlayHeaderView.h"
#import "GSTopicCell.h"


@interface GSPlayViewController () <UITableViewDelegate,UITableViewDataSource,tipBtnClickDelegate> {
    UIButton *tipBtn;
    UIButton *upBtn;
}

//tableview1
@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) NSMutableArray *firstDataArray;

//tableview2
@property (nonatomic, strong) UITableView *secondTableView;
@property (nonatomic, strong) NSMutableArray *secondDataArray;

//tableview2 的头部
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) GSDetailModel *detailModel;

@property (nonatomic, strong) UIView *playerContainerView;

@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) GSPlayHeaderView *headerView;

@property (nonatomic, strong) GSLablsModel *tipModel;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation GSPlayViewController

- (GSPlayHeaderView *) headerView {
    if (!_headerView) {
        _headerView = [[GSPlayHeaderView alloc] init];
    }
    return _headerView;
}
- (NSMutableArray *)firstDataArray {
    if (!_firstDataArray) {
        _firstDataArray = [[NSMutableArray alloc] init];
    }
    return _firstDataArray;
}

- (UITableView *)firstTableView {
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _firstTableView.dataSource = self;
        _firstTableView.delegate = self;
    }
    return _firstTableView;
}
- (NSMutableArray *)secondDataArray {
    if (!_secondDataArray) {
        _secondDataArray = [[NSMutableArray alloc] init];
    }
    return _secondDataArray;
}

- (UITableView *)secondTableView {
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _secondTableView.dataSource = self;
        _secondTableView.delegate = self;
        //此处写入让其不显示下划线的代码
        _secondTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //集成下拉刷新控件
        [self setupDownRefresh];

        //集成上拉刷新控件
        [self setupUpRefresh];
    }
    return _secondTableView;
}
- (UIView *)titieView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}
- (UIView *)playerContainerView {
    if (!_playerContainerView) {
        _playerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    }
    return  _playerContainerView;
}
#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_player play];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_player pause];
}
- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex = 1;
    
    //获取视频详细信息
    [self lodaVideoDetail];
    
    [self initUI];
}

#pragma mark ================ tableView delegate ===================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.firstTableView) {
        return 1;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        return 1;
    } else {
        return self.secondDataArray.count;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        return 0;
    } else {
        return 120;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        return self.headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        //动态计算高度
        self.headerView.delegate = self;
        self.headerView.model = self.detailModel;
        return [self.headerView getViewHeight];
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellId";
    if (tableView == self.secondTableView) {
        GSTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[GSTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.secondDataArray[indexPath.row];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.model = self.dataArray[indexPath.row];
//        cell.backgroundColor = [UIColor yellowColor];
//        cell.textLabel.text = @"ccececec";
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.secondTableView) {
        self.detailModel = self.secondDataArray[indexPath.row];
       
        [self.firstTableView reloadData];
        
        NSURL *url = [NSURL URLWithString:@"https://dhxy.v.netease.com/2019/0813/d792f23a8da810e73625a155f44a5d96qt.mp4"];
        if (!MAIN_TEST) {
            url = [NSURL URLWithString:self.detailModel.videopath];
        }
        
        SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:url];
        asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
            if (MAIN_TEST) {
                make.append(@"SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset");
            } else {
                make.append([GSTools stringEncoding:self.detailModel.title]);
            }
            make.textColor(UIColor.whiteColor);
        }];

        self.player.URLAsset = asset;
        
    }
}

- (void)upBtnClick:(UIButton *)sender {
    self.firstTableView.hidden = NO;
    self.titieView.hidden = YES;
    tipBtn.hidden = YES;
    upBtn.hidden = YES;
    self.secondTableView.hidden = YES;
    self.pageIndex = 1;
}
/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.secondTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewBills)];
    
    // 马上进入刷新状态
    //    [self.secondTableView.mj_header beginRefreshing];
}
/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    self.secondTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBills)];
}
/**
 *  加载下拉刷新数据
 */
- (void)loadNewBills
{
    self.pageIndex = 1;//默认加载第一页
    //获取列表
    [self getTopicList];
}
/**
 *  加载上拉加载数据
 */
-(void)loadMoreBills
{
    //1.设置页数
    self.pageIndex++;//默认加载第二页
    //获取列表
    [self getTopicList];
}
#pragma mark ================ tip delegate ===================
- (void)tipBtnClick:(GSLablsModel *)model {
    self.tipModel = model;
    self.firstTableView.hidden = YES;
    self.titieView.hidden = NO;
    tipBtn.hidden = NO;
    upBtn.hidden = NO;
    float sizeWidth = [self.tipModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size.width + DEFAULT_INTERVAL;
    [tipBtn setTitle:[GSTools stringEncoding:self.tipModel.name] forState:UIControlStateNormal];
    [tipBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sizeWidth+DEFAULT_INTERVAL);
    }];
    self.secondTableView.hidden = NO;
    
    [self getTopicList];
}
- (void)getTopicList {
    
    [GSPlayHandler getTopicList:self.tipModel.ID withPage:self.pageIndex Success:^(id  _Nonnull obj) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:obj[@"rescont"]];
        NSMutableArray *data = dic[@"data"];
        if (self.pageIndex == 1) {
            [self.secondDataArray removeAllObjects];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.secondTableView.mj_header endRefreshing];
        } else {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.secondTableView.mj_footer endRefreshing];
        }
        if (self.pageIndex == (NSInteger)dic[@"last_page"] + 1) {
            //获得了所有数据
            self.pageIndex = (NSInteger)dic[@"last_page"];
            return;
        }
        
        for (NSDictionary *dict in data) {
            GSDetailModel *model = [[GSDetailModel alloc] mj_setKeyValues:dict];
            [self.secondDataArray addObject:model];
        }
        
        [self.secondTableView reloadData];
    } failed:^(id  _Nonnull obj) {
        [HintView showInCurrentViewWithMessage:@"getTopicList---失败"];
        if (self.pageIndex == 1) {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.secondTableView.mj_header endRefreshing];
        } else {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.secondTableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark ================ 获取视频详细信息 ===================
- (void)lodaVideoDetail {
    [GSPlayHandler playVideoId:self.playID Success:^(id  _Nonnull obj) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:obj[@"rescont"]];
        self.detailModel = [[GSDetailModel alloc] mj_setKeyValues:dic];
        [self.firstTableView reloadData];
        
        NSURL *url = [NSURL URLWithString:@"https://dhxy.v.netease.com/2019/0813/d792f23a8da810e73625a155f44a5d96qt.mp4"];
        if (!MAIN_TEST) {
            url = [NSURL URLWithString:self.detailModel.videopath];
        }
        
        SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:url];
        asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
            if (MAIN_TEST) {
                make.append(@"SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset");
            } else {
                make.append([GSTools stringEncoding:self.detailModel.title]);
            }
            make.textColor(UIColor.whiteColor);
        }];

        self.player.URLAsset = asset;
        NSLog(@"dddd");
    } failed:^(id  _Nonnull obj) {
         NSLog(@"ssss");
    }];
}

//初始化UI
- (void) initUI {
    
    //播放器
    [self.view addSubview:self.playerContainerView];
    
    _player = [SJVideoPlayer player];
    _player.defaultEdgeControlLayer.showResidentBackButton = YES;
    _player.pausedToKeepAppearState = YES;
    _player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
    
//    self.asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://dhxy.v.netease.com/2019/0813/d792f23a8da810e73625a155f44a5d96qt.mp4"]];
//    self.asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
//        make.append(@"SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset");
//        make.textColor(UIColor.whiteColor);
//    }];
//
//    _player.URLAsset = self.asset;
    [_playerContainerView addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    __weak typeof(self) _self = self;
    _player.rotationObserver.rotationDidStartExeBlock = ^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
    };
    
    self.firstTableView.hidden = NO;
    [self.view addSubview:self.firstTableView];
    [self.firstTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.playerContainerView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    self.titleView.hidden = YES;
    [self.view addSubview:self.titieView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.playerContainerView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    [self createTitleView];
    
    self.secondTableView.hidden = YES;
    [self.view addSubview:self.secondTableView];
    [self.secondTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
}
- (void)createTitleView {
    tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tipBtn.hidden = YES;
    [tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    tipBtn.backgroundColor = RGB(255, 105, 180);
    tipBtn.layer.cornerRadius = 6;
    tipBtn.layer.borderWidth = 1;
    tipBtn.layer.borderColor = RGB(255, 105, 180).CGColor;
    [self.titleView addSubview:tipBtn];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleView.mas_left).offset(DEFAULT_INTERVAL/2);
        make.top.mas_equalTo(self.titleView.mas_top).offset(3);
        make.width.mas_equalTo(DEFAULT_INTERVAL);
        make.height.mas_equalTo(30);
    }];

    upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.hidden = YES;
    [upBtn setImage:[UIImage imageNamed:@"pull-arrow"] forState:UIControlStateNormal];
    [self.titleView addSubview:upBtn];
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleView.mas_right).offset(-DEFAULT_INTERVAL/2);
        make.top.bottom.mas_equalTo(self.titleView);
        make.width.mas_equalTo(80);
    }];
    [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


@end
