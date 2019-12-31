//
//  GSBaseViewController.m
//  SeVideo
//
//  Created by 耿双 on 2019/8/14.
//  Copyright © 2019 GS. All rights reserved.
//

#import "GSBaseViewController.h"

@interface GSBaseViewController ()

@end

@implementation GSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
    self.view.backgroundColor = [GSTools returnBackgroungColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
