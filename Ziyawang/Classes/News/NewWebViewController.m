//
//  NewWebViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/7.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "NewWebViewController.h"

@interface NewWebViewController ()

@end

@implementation NewWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    
  UIWebView *webView =  [[UIWebView alloc]initWithFrame:self.view.bounds];
    [webView loadRequest:self.request];
    [self.view addSubview:webView];
    webView.scalesPageToFit = YES;
    
    
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
