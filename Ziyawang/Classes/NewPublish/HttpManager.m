//
//  HttpManager.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "HttpManager.h"

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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
[manager POST:URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if (imageArray.count>0) {
        for (int i = 0; i<imageArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1.0f);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"PictureDes%d",i+1] fileName:[NSString stringWithFormat:@"image%d",i+1] mimeType:@"image/jpg/png/jpeg"];
        }
    }
   
     if (url != nil) {
         [formData appendPartWithFileURL:url name:@"VoiceDes" error:nil];
     }
    
  } progress:^(NSProgress * _Nonnull uploadProgress) {
      
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      NSLog(@"%@",dic);
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
      [alert show];

  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
      NSLog(@"%@",error);
      
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布失败，请稍后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
      [alert show];
      
  }];
    
}

@end
