//
//  HttpManager.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "HttpManager.h"

@interface HttpManager ()<MBProgressHUDDelegate>
@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation HttpManager

+(HttpManager *)httpManager
{
    static dispatch_once_t onceToken;
    static HttpManager *defaultManager = nil;
 
    dispatch_once(&onceToken, ^{
        defaultManager = [[HttpManager alloc]init];
    });
    
    return defaultManager;
}


- (void)postDataWithURL:(NSString *)URL ImageArray:(NSMutableArray *)imageArray audioURL:(NSURL *)url param:(NSMutableDictionary *)param
{
    self.HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication]keyWindow] animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
[manager POST:URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if (imageArray.count>0) {
        for (int i = 0; i<imageArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1.0f);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"PictureDes%d",i+1] fileName:[NSString stringWithFormat:@"image%d.png",i+1] mimeType:@"image/jpg/png/jpeg"];
        }
    }
     if (url != nil) {
         [formData appendPartWithFileURL:url name:@"VoiceDes" error:nil];
     }
    
  } progress:^(NSProgress * _Nonnull uploadProgress) {
      
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      NSLog(@"%@",dic);
      

      if (!param[@"StarID"]) {
          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
          [alert show];
      }
      else
      {
          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已提交审核，客服人员稍后会与您联系！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
          [alert show];
      }
      NSString *statu = @"成功";
      [self.HUD removeFromSuperViewOnHide];
      [self.HUD hideAnimated:YES];
      self.ifpop(statu);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
      NSLog(@"%@",error);
      
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布失败，请稍后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
      [alert show];
      NSString *statu = @"失败";
      [self.HUD removeFromSuperViewOnHide];
      [self.HUD hideAnimated:YES];
      self.ifpop(statu);
  }];
    
}

@end
