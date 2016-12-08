//
//  UpdateAppController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/8.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "UpdateAppController.h"

@interface UpdateAppController ()

@end

@implementation UpdateAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageV.image = [UIImage imageNamed:@"pic01"];
    [self.view addSubview:imageV];
//    [self popUpdateAlert];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self popUpdateAlert];

}
- (void)popUpdateAlert
{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:self.updateDes preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即更新" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/zi-ya/id1148016346?l=zh&ls=1&mt=8"]];
        }];
//        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
