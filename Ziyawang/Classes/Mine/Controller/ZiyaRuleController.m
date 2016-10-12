//
//  ZiyaRuleController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/10/11.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ZiyaRuleController.h"

@interface ZiyaRuleController ()

@end

@implementation ZiyaRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资芽声明(免费公约等)";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *URL = [AudioURL stringByAppendingString:@"/law.html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
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
