//
//  YabiRuleController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/10/12.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "YabiRuleController.h"

@interface YabiRuleController ()

@end

@implementation YabiRuleController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.navigationItem.title = @"资芽网芽币使用协议";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *URL = [AudioURL stringByAppendingString:@"/rechargeproto.html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    [self.view addSubview:webView];
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
