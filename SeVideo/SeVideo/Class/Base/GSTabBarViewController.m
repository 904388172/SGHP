//
//  GSTabBarViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/8/14.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSTabBarViewController.h"
#import "GSTabBar.h"
#import "GSBaseNavViewController.h"

@interface GSTabBarViewController () <GSTabBarDelegate>

@property (nonatomic, strong) GSTabBar *gsTabBar;

@end

@implementation GSTabBarViewController

- (GSTabBar *)gsTabBar {
    if (!_gsTabBar) {
        _gsTabBar = [[GSTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _gsTabBar.delegate = self;
    }
    return _gsTabBar;
}

//代理回调
- (void)tabbar:(GSTabBar *)tabbar clickButton:(GSItemType)index {
    self.selectedIndex = index - GSItemTypeLive;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载控制器
    [self configViewControllers];
    
    //加载tabbar
    [self.tabBar addSubview:self.gsTabBar];
    
    //删除tabbar的阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}

//加载控制器
- (void)configViewControllers {
    if (G_CARRIR_TYPE == CARRIER_TYPE_MAIN) {
    
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"GSMainViewController",@"GSFindViewController",@"GSMineViewController"]];
        for (NSInteger i = 0; i < array.count; i++) {
            NSString *vcName = array[i];
            UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
            
            GSBaseNavViewController *nav = [[GSBaseNavViewController alloc] initWithRootViewController:vc];
            
            [array replaceObjectAtIndex:i withObject:nav];
        }
        
        self.viewControllers = array;
    } else {
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"GSAudioMainViewController",@"GSAudioCategoryViewController",@"GSAudioShareViewController",@"GSAudioMineViewController"]];
        for (NSInteger i = 0; i < array.count; i++) {
            NSString *vcName = array[i];
            UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
            
            GSBaseNavViewController *nav = [[GSBaseNavViewController alloc] initWithRootViewController:vc];
            
            [array replaceObjectAtIndex:i withObject:nav];
        }
        self.viewControllers = array;
    }
}
@end
