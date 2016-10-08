//
//  HahaController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/10.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "HahaController.h"
#import "VideosViewCell.h"
#import "AFNetWorking.h"
#import "VideosModel.h"
#import "ZXVideo.h"
#import "VideoPlayViewController.h"
@interface HahaController ()<UITableViewDelegate,UITableViewDataSource,playDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,assign) NSInteger startPage;
@property (nonatomic,strong) ZXVideo *zvideo;

@property (nonatomic,strong) NSString *videoURL;
@end

@implementation HahaController

- (void)pushToControllerWithZXVideo:(ZXVideo *)zvideo model:(VideosModel *)model
{
    
    
    
    //    model = self.sourceArray[indexPath.row];
    //    NSString *headURL = @"http://videos.ziyawang.com";
    
    //    self.zvideo.title = model.VideoTitle;
    //    self.zvideo.playUrl = [headURL stringByAppendingString:model.VideoLink];
    //    VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc]init];
    //    videoPlayVC.videoTitle = model.VideoTitle;
    //    videoPlayVC.videoDes = model.VideoDes;
    //    videoPlayVC.viewCount = [NSString stringWithFormat:@"%@",model.ViewCount];
    //        videoPlayVC.commentTime = model.PublishTime;
    //    videoPlayVC.videoID = [NSString stringWithFormat:@"%@",model.VideoID];
    //
    //    videoPlayVC.video = self.zvideo;
    //    NSLog(@"222222%@",self.navigationController);
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    userInfo[@"zvideoModel"] = zvideo;
    userInfo[@"model"] = model;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zvideo = [[ZXVideo alloc]init];

    self.sourceArray = [NSMutableArray new];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VideosViewCell" bundle:nil] forCellReuseIdentifier:@"VideosViewCell"];

    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getNewVideosList];
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

}

- (void)loadMoreData
{
//    NSString *headurl = @"http://api.ziyawang.com/v1";
//    NSString *footurl = @"/video/list";
    NSString *URL =getVideoListURL;
    NSString *accesstoken = @"token";
    NSString *VideoLabel = @"zyhhh";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:accesstoken forKey:@"access_token"];
    //    [dic setObject:pagecount forKey:@"pagecount"];
    [dic setObject:VideoLabel forKey:@"VideoLabel"];
    [dic setObject:[NSString stringWithFormat:@"%ld",self.startPage] forKey:@"startpage"];
    
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取信息成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *dataArray = dic[@"data"];
        NSMutableArray *addArray = [NSMutableArray new];
        
        
        for (NSDictionary *dic in dataArray) {
            
            VideosModel *model = [[VideosModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [addArray addObject:model];
        }
        self.startPage ++;
        if (addArray.count == 0) {
            //            [self.tableView.mj_footer resetNoMoreData];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];

        }
        else
        {
        [self.sourceArray addObjectsFromArray:addArray];
        NSLog(@"%@",self.sourceArray);
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取信息失败");
        NSLog(@"%@",error);
        [self.tableView.mj_footer endRefreshing];

        [self showAlertWithMessage:@"信息获取失败，请检查您的网络状态"];
        
    }];
}


- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}
//
- (void)getNewVideosList
{
    [self.sourceArray removeAllObjects];
    
    self.startPage = 1;
//    NSString *headurl = @"http://api.ziyawang.com/v1";
//    NSString *footurl = @"/video/list";
    NSString *URL =getVideoListURL;
    NSString *accesstoken = @"token";
    NSString *VideoLabel = @"zyhhh";
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:accesstoken forKey:@"access_token"];
    
    //    [dic setObject:pagecount forKey:@"pagecount"];
    [dic setObject:VideoLabel forKey:@"VideoLabel"];
    
    
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取信息成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *dataArray = dic[@"data"];
        
      
            for (NSDictionary *dic in dataArray) {
                VideosModel *model = [[VideosModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.sourceArray addObject:model];
            }
            self.startPage ++;
            NSLog(@"%@",self.sourceArray);
            [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取信息失败");
        NSLog(@"%@",error);
        [self showAlertWithMessage:@"获取信息失败，请检查您的网络状况"];
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 230;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 250;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 270;
        
    }
    return 270;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideosViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideosViewCell" forIndexPath:indexPath];
    cell.model = self.sourceArray[indexPath.row];
    cell.zvideo = self.zvideo;
    cell.Mydelegate = self;    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    VideosModel *model = [[VideosModel alloc]init];
    model = self.sourceArray[indexPath.row];
    //    NSString *headURL = @"http://videos.ziyawang.com";
    
    //    self.zvideo.title = model.VideoTitle;
    //    self.zvideo.playUrl = [headURL stringByAppendingString:model.VideoLink];
    //    VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc]init];
    //    videoPlayVC.videoTitle = model.VideoTitle;
    //    videoPlayVC.videoDes = model.VideoDes;
    //    videoPlayVC.viewCount = [NSString stringWithFormat:@"%@",model.ViewCount];
    //        videoPlayVC.commentTime = model.PublishTime;
    //    videoPlayVC.videoID = [NSString stringWithFormat:@"%@",model.VideoID];
    //
    //    videoPlayVC.video = self.zvideo;
    //    NSLog(@"222222%@",self.navigationController);
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    userInfo[@"zvideoModel"] = _zvideo;
    userInfo[@"model"] = model;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
    
    
    
    //    [self.navigationController pushViewController:videoPlayVC animated:YES];
    //    [self presentViewController:videoPlayVC animated:YES completion:nil];
    
    //    [self.navigationController pushViewController:videoPlayVC animated:YES];
    
    //    [self presentViewController:videoPlayVC animated:YES completion:nil];
}



@end
