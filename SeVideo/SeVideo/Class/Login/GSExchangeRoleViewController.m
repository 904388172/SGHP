//
//  GSExchangeRoleViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/9/6.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSExchangeRoleViewController.h"
#import "GSUserDefaultStatus.h"
#import "GSSQLManager.h"

@interface GSExchangeRoleViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GSExchangeRoleViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改权限";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    //此处写入让其不显示下划线的代码
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self getAllUsers];
}
- (void)getAllUsers {
    [self.dataArray removeAllObjects];
    self.dataArray = [[GSSQLManager shareDatabase] queryAllUserInfo];
    [self.tableView reloadData];
}

#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.section][@"username"];
    if ([self.dataArray[indexPath.section][@"status"] isEqualToString:@"1"]) {
        cell.detailTextLabel.text = @"超级管理员";
    } else if ([self.dataArray[indexPath.section][@"status"] isEqualToString:@"2"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"VIP用户";
    } else {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"普通用户";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.section][@"status"] isEqualToString:@"1"]) {
        return;
    } else {        
        //1.创建Controller
        UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"修改用户权限" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        //2.添加按钮动作
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"VIP用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[GSSQLManager shareDatabase] updateUserInfo:self.dataArray[indexPath.section][@"username"] withKey:@"status" withValue:@"2"];
            //可删除
            [self getAllUsers];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"普通用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[GSSQLManager shareDatabase] updateUserInfo:self.dataArray[indexPath.section][@"username"] withKey:@"status" withValue:@"3"];
            //可删除
            [self getAllUsers];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        //3.添加动作
        [alertSheet addAction:action1];
        [alertSheet addAction:action2];
        [alertSheet addAction:cancel];
        
        //4.显示sheet
        [self presentViewController:alertSheet animated:YES completion:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.section][@"status"] isEqualToString:@"1"]) {
        return NO;
    } else {
        //可删除
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.section][@"status"] isEqualToString:@"1"]) {
        return;
    } else {
        [[GSSQLManager shareDatabase] deleteUserInfo:self.dataArray[indexPath.section][@"username"]];
        //可删除
        [self getAllUsers];
    }
}

@end
