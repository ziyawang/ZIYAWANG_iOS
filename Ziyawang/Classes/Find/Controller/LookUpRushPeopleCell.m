//
//  LookUpRushPeopleCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/8.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "LookUpRushPeopleCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "talkViewController.h"

@interface LookUpRushPeopleCell ()<MBProgressHUDDelegate>
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (weak, nonatomic) IBOutlet UILabel *operateStateButton;

@end


@implementation LookUpRushPeopleCell

- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
    
}

- (void)setModel:(RushPeopleModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setDataForCell];
        
    }
}
- (void)setPublishState:(NSString *)PublishState
{
    if (_PublishState != PublishState) {
        _PublishState = nil;
        _PublishState = PublishState;
        [self setStateForCell];
    }
}
- (void)setDataForCell
{
    
//   NSString *headURL = @"http://images.ziyawang.com";
    NSString *URL = [getImageURL stringByAppendingString:self.model.UserPicture];
    [self.usericonImageView sd_setImageWithURL:[NSURL URLWithString:URL]];
    self.usericonImageView.layer.masksToBounds = YES;
    self.usericonImageView.layer.cornerRadius = 30;
        self.numberLable.text = self.model.ServiceNumber;
    self.phoneNumberLabel.text = self.model.ConnectPhone;
    self.model.CooperateFlag = [NSString stringWithFormat:@"%@",self.model.CooperateFlag];
    
    self.model.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
    
    
    

//    
//if ([self.model.CooperateFlag isEqualToString:@"0"]) {
//        NSLog(@"未合作");
////        [self.agreeButton setBackgroundImage:[UIImage imageNamed:@"hezuo-hui"] forState:(UIControlStateNormal)];
//        [self.agreeButton setHidden:YES];
//    }
//    else
//    {
//      [self.agreeButton setBackgroundImage:[UIImage imageNamed:@"hezuo"] forState:(UIControlStateNormal)];
//    }
    
    NSLog(@"搜藏的状态！！！！！%@",self.model.CollectFlag);
    if ([self.model.CollectFlag isEqualToString:@"0"]) {
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    }
    else
    {
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
    }
  }
- (IBAction)saveButtonAction:(id)sender {
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([self.model.CollectFlag isEqualToString:@"0"]) {
        [self saveAction];
    }
    
    else
    {
        [self saveAction];
    }
       }


- (void)setStateForCell
{
    
    NSLog(@"publishstate:%@",self.PublishState);
    if ([self.PublishState isEqualToString:@"0"])
    {
        [self.agreeButton setHidden:NO];
        //
        //        [self.agreeButton setTitle:@"抢单中" forState:(UIControlStateNormal)];
        [self.operateStateButton setText:@"确认合作"];
    }
    else if ([self.PublishState isEqualToString:@"1"])
    {
        if ([self.model.CooperateFlag isEqualToString:@"1"]) {
            [self.agreeButton setHidden:NO];
            [self.operateStateButton setText:@"合作中"];
        }
        else
        {
            [self.agreeButton setHidden:YES];
            //            self.operateStateButton.text = @"取消中";
            //            [self.operateStateButton setText:@"取消中"];
            
        }
        
    }
    
    else if([self.PublishState isEqualToString:@"2"])
    {
        [self.agreeButton setHidden:YES];
        [self.operateStateButton setText:@"取消中"];
//        [self.agreeButton setTitle:@"取消中" forState:(UIControlStateNormal)];
        
    }
}





- (void)saveAction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *Token = @"?token=";
    NSString *url = @"http://api.ziyawang.com/v1";
    NSString *url2 = @"/collect";
    NSString *access_token = @"token";
    
    NSString *URL = [[[url stringByAppendingString:url2]stringByAppendingString:Token]stringByAppendingString:token];
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    NSString *accesstoken = @"token";
    NSString *type = @"4";
    self.model.ServiceID = [NSString stringWithFormat:@"%@",self.model.ServiceID];
    //    [paraDic setObject:token forKey:@"token"];
    [paraDic setObject:accesstoken forKey:@"access_token"];
    [paraDic setObject:type forKey:@"type"];
    [paraDic setObject:self.model.ServiceID forKey:@"itemID"];
    
    [self.manager POST:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"收藏成功");
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
        NSLog(@"收藏状态2----%@",self.model.CollectFlag);
        NSString *status_code = [NSString stringWithFormat:@"%@",dic[@"status_code"]];
        
        if ([status_code isEqualToString:@"200"]) {
            if ([self.model.CollectFlag isEqualToString:@"0"]) {
                [self MBProgressWithString:@"收藏成功" timer:1 mode:MBProgressHUDModeText];
                [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
                
                self.model.CollectFlag =@"1";
                
            }
            else
            {
                [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
                [self MBProgressWithString:@"取消收藏成功" timer:1 mode:MBProgressHUDModeText];
                
                self.model.CollectFlag = @"0";
            }

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if ([self.model.CollectFlag isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            [self MBProgressWithString:@"收藏失败,请检查您的网络状态" timer:1 mode:MBProgressHUDModeText];
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            [self MBProgressWithString:@"取消收藏失败，请检查您的网络状态" timer:1 mode:MBProgressHUDModeText];
            
        }
        NSLog(@"请求失败%@",error);
    }];


}
- (IBAction)agreeButtonAction:(id)sender {
    
    if ([self.model.CooperateFlag isEqualToString:@"0"]) {
        [self agreeAction];
    }
    else
    {
//        [self agreeAction];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已与该服务方经合作" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }

}


- (void)agreeAction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *headurl = @"http://api.ziyawang.com/v1";
    NSString *footurl = @"/project/cooperate";
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.ProjectID= [NSString stringWithFormat:@"%@",self.ProjectID];
    NSLog(@"#################################%@",self.model.ServiceID);
    self.model.ServiceID = [NSString stringWithFormat:@"%@",self.model.ServiceID];
    NSString *URL= [[[[[[[[headurl stringByAppendingString:footurl]stringByAppendingString:@"?access_token=token"]stringByAppendingString:@"&token="]stringByAppendingString:token]stringByAppendingString:@"&ServiceID="]stringByAppendingString:self.model.ServiceID]stringByAppendingString:@"&ProjectID="]stringByAppendingString:self.ProjectID];
    
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",URL);
    NSLog(@"serviceID:%@,projectID:%@",self.model.ServiceID,self.ProjectID);
    //    NSString *URL =[headurl stringByAppendingString:footurl];
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    //        NSString *accesstoken = @"token";
    //    [paraDic setObject:token forKey:@"token"];
    //    [paraDic setObject:accesstoken forKey:@"access_token"];
    //    [paraDic setObject:self.model.ServiceID forKey:@"ServiceID"];
    //    [paraDic setObject:self.ProjectID forKey:@"ProjectID"];
    
    [self.manager POST:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"合作成功");
        [self MBProgressWithString:@"合作成功" timer:1 mode:MBProgressHUDModeText];
        NSLog(@"%@",dic[@"status_code"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
//        [self MBProgressWithString:@"合作失败" timer:1 mode:MBProgressHUDModeText];
        NSLog(@"合作失败%@",error);
    }];

}

//通知事件响应跳转到私聊界面
- (IBAction)talkButtonAction:(id)sender {
    
//    talkViewController *talkVC = [[talkViewController alloc]init];
    if (self.Mydelegate != nil && [self.Mydelegate respondsToSelector:@selector(pushToControllerWithModel:)]) {
        [self.Mydelegate pushToControllerWithModel:self.model];
    }
    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    
//    userInfo[@"zvideoModel"] = _zvideo;
//    userInfo[@"model"] = model;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
