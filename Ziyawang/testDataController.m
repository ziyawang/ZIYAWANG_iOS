//
//  testDataController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "testDataController.h"
//
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface testDataController ()

@end

@implementation testDataController



- (IBAction)collcetion:(id)sender {
}

- (IBAction)shareButton:(id)sender

{
//    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
////    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://mob.com"]
//                                          title:@"分享标题"
//                                          type:SSDKContentTypeAuto];
//        
//        [ShareSDK showShareActionSheet:nil
//         //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
//         {
//                       
//                       switch (state)
//             {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"message:nil delegate:nil
//                                   cancelButtonTitle:@"确定"
//                                   otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"message:[NSString stringWithFormat:@"%@",error]
//                                   delegate:nil
//                                 cancelButtonTitle:@"OK"
//                                 otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//             }
//                       }];
//                       
//
//    }
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
}


         

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
