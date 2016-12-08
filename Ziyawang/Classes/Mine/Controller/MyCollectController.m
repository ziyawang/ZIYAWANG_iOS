//
//  MyCollectController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MyCollectController.h"
#import "MBProgressHUD.h"
#import "CollectModel.h"
//#import "CollectInfoCell.h"
#import "LoginController.h"
#import "InfoDetailsController.h"
#import "ServiceDetailController.h"
#import "VideoPlayViewController.h"
#import "ZXVideo.h"
#import "CollectInfoViewCell.h"
#import "CollectServiceViewCell.h"
#import "CollectVideoViewCell.h"
#import "CollectNewsCell.h"
#import "NewsDetailController.h"
#import "DetailOfInfoController.h"
//#import "CollectInfomationCell.h"
@interface MyCollectController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *videoArray;
@property (nonatomic,strong) NSMutableArray *infoArray;
@property (nonatomic,strong) NSMutableArray *serviceArray;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) ZXVideo *zvideo;
@property (nonatomic,assign) NSInteger startpage;
@property (nonatomic,strong) UIView *PromiseView;
@end

@implementation MyCollectController

- (void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  self.zvideo = [[ZXVideo alloc]init];
    self.sourceArray = [NSMutableArray new];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectInfoViewCell" bundle:nil] forCellReuseIdentifier:@"CollectInfoViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectServiceViewCell" bundle:nil] forCellReuseIdentifier:@"CollectServiceViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectVideoViewCell" bundle:nil] forCellReuseIdentifier:@"CollectVideoViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectNewsCell" bundle:nil] forCellReuseIdentifier:@"CollectNewsCell"];
    
    self.tableView.separatorStyle = NO;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

    [self.view addSubview:self.tableView];
    
    
    [self getCollectionData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getCollectionData
{
    self.startpage = 1;
    NSString *url1 = getDataURL;
    NSString *url2 = @"/app/collect/list?token=";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *URL = [[url1 stringByAppendingString:url2]stringByAppendingString:token];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:@"token" forKey:@"access_token"];
    
[self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSLog(@"请求收藏列表成功");
    NSLog(@"-------------%@",responseObject);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = dic[@"data"];
    for (NSDictionary *dic in dataArray)
    {
        CollectModel *model = [[CollectModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.sourceArray addObject:model];
    }
    if (self.sourceArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未收藏任何信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    self.startpage ++;
    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];

    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}];

}

- (void)loadMoreData
{
    NSString *url1 = getDataURL;
    NSString *url2 = @"/app/collect/list?token=";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    NSString *URL = [[url1 stringByAppendingString:url2]stringByAppendingString:token];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:@"token" forKey:@"access_token"];
    [paraDic setObject:[NSString stringWithFormat:@"%ld",self.startpage] forKey:@"startpage"];
    [self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"请求收藏列表成功");
        NSLog(@"-------------%@",responseObject);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArray = dic[@"data"];
        NSMutableArray *addArray = [NSMutableArray new];
        for (NSDictionary *dic in dataArray)
        {
            CollectModel *model = [[CollectModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [addArray addObject:model];
            
        }
        if (addArray.count == 0) {
            //            [self.tableView.mj_footer resetNoMoreData];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];

        }
        else
        {
        [self.sourceArray addObjectsFromArray:addArray];
         self.startpage ++;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.tableView.mj_footer endRefreshing];

    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectModel *model = [[CollectModel alloc]init];
    model = self.sourceArray[indexPath.row];
    NSString *TypeID  = [NSString stringWithFormat:@"%@",model.TypeID];
    if ([TypeID isEqualToString:@"1"])
    {
        return 120;
    }
    else if ([TypeID isEqualToString:@"4"])
    {
        return 120;
    }
   else
   {
       return 122;
   
   }
    return 155;
    

}

- (void)setPromiseView
{
    UIView *mengbanView= [UIView new];
    UIView *weituoView = [UIView new];
    UIImageView *tuziImage = [UIImageView new];
    UIView *imageBackView = [UIView new];
    
    UIView *bottomView = [UIView new];
    
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    
    
    UIButton *fabuButton = [UIButton new];
    UIButton *fanhuiButton = [UIButton new];
    UIButton *cancelButton = [UIButton new];
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:mengbanView];
    
    [mengbanView addSubview:weituoView];
    [weituoView addSubview:imageBackView];
    [imageBackView addSubview:tuziImage];
    [imageBackView addSubview:cancelButton];
    [weituoView addSubview:bottomView];
    
    [bottomView addSubview:label1];
    [bottomView addSubview:label2];
    
    [bottomView addSubview:fabuButton];
    [bottomView addSubview:fanhuiButton];
    
    mengbanView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    imageBackView.backgroundColor = [UIColor colorWithHexString:@"#5dc1cf"];
    weituoView.backgroundColor = [UIColor whiteColor];
    
    
    
    mengbanView.sd_layout.leftSpaceToView(window,0)
    .rightSpaceToView(window,0)
    .topSpaceToView(window,0)
    .bottomSpaceToView(window,0);
    
    weituoView.sd_layout.centerXEqualToView(mengbanView)
    .centerYIs(self.view.centerY)
    .widthIs(285 * kWidthScale)
    .heightIs(300 * kHeightScale);
    
    imageBackView.sd_layout.leftSpaceToView(weituoView,0)
    .rightSpaceToView(weituoView,0)
    .heightIs(140 * kHeightScale)
    .topSpaceToView(weituoView,0);
    
    tuziImage.sd_layout.centerXEqualToView(imageBackView)
    .centerYEqualToView(imageBackView)
    .heightIs(95*kHeightScale)
    .widthIs(90*kWidthScale);
    tuziImage.image = [UIImage imageNamed:@"TUZI"];
    
    bottomView.sd_layout.leftSpaceToView(weituoView,0)
    .rightSpaceToView(weituoView,0)
    .topSpaceToView(imageBackView,0)
    .bottomSpaceToView(weituoView,0);
    
    
    
    label1.sd_layout.centerXEqualToView(bottomView)
    .topSpaceToView(bottomView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    label1.text = @"温馨提示";
    
    label2.sd_layout.leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15)
    .topSpaceToView(label1,15)
    .autoHeightRatio(0);
    
    label2.text = @"本条VIP信息只针对本类型会员免费开放，详情请咨询会员专线：010-56052557";
    label2.font = [UIFont systemFontOfSize:13];
    
    
    
    
    
    fabuButton.sd_layout.leftEqualToView(label2)
    .rightEqualToView(label2)
    .topSpaceToView(label2,30*kHeightScale)
    .heightIs(40*kHeightScale);
    [fabuButton setTitle:@"确定" forState:(UIControlStateNormal)];
    fabuButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
    //    fanhuiButton.sd_layout.leftEqualToView(label2)
    //    .rightEqualToView(label2)
    //    .topSpaceToView(fabuButton,20)
    //    .heightIs(40*kHeightScale);
    //    fanhuiButton.layer.borderWidth = 1.5;
    //    fanhuiButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    
    
    cancelButton.sd_layout.rightSpaceToView(imageBackView,10)
    .topSpaceToView(imageBackView,10)
    .heightIs(25)
    .widthIs(25);
    
    
    
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(CancelAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //    [fanhuiButton setTitle:@"不承诺" forState:(UIControlStateNormal)];
    //    [fanhuiButton addTarget:self action:@selector(didClickFanhuiButtonAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [fabuButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [fanhuiButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [fabuButton addTarget:self action:@selector(didClickfabuFabuAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //    self.weituoView = weituoView;
    weituoView.layer.cornerRadius = 10;
    weituoView.layer.masksToBounds = YES;
    self.PromiseView = mengbanView;
    //    [self.PromiseView setHidden:YES];
    
    
}

- (void)CancelAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
}

- (void)didClickfabuFabuAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectModel *model = [[CollectModel alloc]init];
    model = self.sourceArray[indexPath.row];
    NSString *TypeID  = [NSString stringWithFormat:@"%@",model.TypeID];
    if ([TypeID isEqualToString:@"1"]) {
        
        CollectInfoViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"CollectInfoViewCell" forIndexPath:indexPath];
        infoCell.model = model;
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return infoCell;
     
    }
    else if([TypeID isEqualToString:@"4"])
    {
        CollectServiceViewCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:@"CollectServiceViewCell" forIndexPath:indexPath];
        serviceCell.model = model;
        serviceCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return serviceCell;
    }
    else if([TypeID isEqualToString:@"2"])
    {
        CollectVideoViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"CollectVideoViewCell" forIndexPath:indexPath];
        videoCell.model = model;
         videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return videoCell;
    }
    else
    {
        CollectNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"CollectNewsCell" forIndexPath:indexPath];
        newsCell.model = model;
        newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return newsCell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectModel *model = [[CollectModel alloc]init];
    model = self.sourceArray[indexPath.row];
    NSString *TypeID  = [NSString stringWithFormat:@"%@",model.TypeID];
    if ([TypeID isEqualToString:@"1"]) {
        
        
        if ([model.Member isEqualToString:@"1"]) {
            [self setPromiseView];
        }
        
        else
        {
        DetailOfInfoController *infoDetailsVC = [[DetailOfInfoController alloc]init];
        infoDetailsVC.ProjectID = model.ProjectID;
        infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
        infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
        infoDetailsVC.typeName = model.TypeName;

        [self.navigationController pushViewController:infoDetailsVC animated:YES];
        }
    }
    else if([TypeID isEqualToString:@"4"])
    {
        
        ServiceDetailController *ServiceDetailVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDetailController"];
        ServiceDetailVC.ServiceID = model.ServiceID;
        ServiceDetailVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
        [self.navigationController pushViewController:ServiceDetailVC animated:YES];
    }
    else if([TypeID isEqualToString:@"2"])
    {
        self.zvideo.title = model.VideoTitle;
        if (model.VideoLink ==nil) {
        self.zvideo.playUrl = [videoPlayerURL stringByAppendingString:model.VideoLink2];
        }
        else
        {
        self.zvideo.playUrl = [videoPlayerURL stringByAppendingString:model.VideoLink];
        }
        NSLog(@"_______________%@",self.zvideo.playUrl);
        VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc]init];
        videoPlayVC.videoTitle = model.VideoTitle;
        videoPlayVC.videoDes = model.VideoDes;
        videoPlayVC.viewCount = [NSString stringWithFormat:@"%@",model.ViewCount];
        videoPlayVC.commentTime = model.PublishTime;
        videoPlayVC.videoID = [NSString stringWithFormat:@"%@",model.VideoID];
        videoPlayVC.video = self.zvideo;
        NSLog(@"@@@@@@@@@@@@@@@@@@@%@",videoPlayVC.video.playUrl);
        
        //    NSLog(@"222222%@",self.navigationController);
        
        [self.navigationController pushViewController:videoPlayVC animated:YES];
    }
    else
    {
        NewsDetailController *newsDetailVC = [[NewsDetailController alloc]init];
        newsDetailVC.NewsID = model.NewsID;
        [self.navigationController pushViewController:newsDetailVC animated:YES];
        
    
    }

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要取消收藏吗" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            CollectModel *model = [[CollectModel alloc]init];
            model = self.sourceArray[indexPath.row];
             [self.sourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [defaults objectForKey:@"token"];
            NSString *Token = @"?token=";
            NSString *url = getDataURL;
            NSString *url2 = @"/collect";
            NSString *access_token = @"token";
            
            NSString *URL = [[[url stringByAppendingString:url2]stringByAppendingString:Token]stringByAppendingString:token];
            
            //    NSString *getURL = @"http://api.ziyawang.com/v1/service/list?access_token=token";
            NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
            [postdic setObject:access_token forKey:@"access_token"];
            //    [postdic setObject:token forKey:@"token"];
            
            //空
            model.TypeID = [NSString stringWithFormat:@"%@",model.TypeID];
            model.ProjectID = [NSString stringWithFormat:@"%@",model.ProjectID];
            model.ServiceID = [NSString stringWithFormat:@"%@",model.ServiceID];
            model.NewsID = [NSString stringWithFormat:@"%@",model.NewsID];
            
            
            if ([model.TypeID isEqualToString:@"1"]) {
                [postdic setObject:model.ProjectID forKey:@"itemID"];
                NSLog(@"取消的为信息为：------%@",model.ProjectID);
            }
            
            else if([model.TypeID isEqualToString:@"2"])
            {
                [postdic setObject:model.VideoID forKey:@"itemID"];
                NSLog(@"取消的视频为：----%@",model.VideoID);
            }
            else if([model.TypeID isEqualToString:@"4"])
            {
                [postdic setObject:model.ServiceID forKey:@"itemID"];
                NSLog(@"取消的服务为：------%@",model.ServiceID);
            }
            else if ([model.TypeID isEqualToString:@"3"])
            {
                [postdic setObject:model.NewsID forKey:@"itemID"];

            }
            
            [postdic setObject:model.TypeID forKey:@"type"];
            
            [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
             {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 NSLog(@"%@",dic);
                 NSLog(@"取消收藏成功");
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
                 NSLog(@"取消收藏失败");
             }];

        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
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
