//
//  MainController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/27.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MainController.h"
#import "MainSectionHeadView.h"
#import "SDVersion.h"
#import "SDiOSVersion.h"
#import "SearchBar.h"
#import "PublishCell.h"
#import "AFNetWorking.h"
#import "PublishModel.h"
@interface MainController ()<UIScrollViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UIView *backView2;


@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *searchBarbutton;

@property (nonatomic,strong) UIButton *findButton;

@property (nonatomic,strong) NSString *infoType;

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) PublishModel *model;
@property (nonatomic,assign) BOOL reload;


@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *searchView;


@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PublishCell" bundle:nil] forCellReuseIdentifier:@"PublishCell"];
    

    self.sourceArray = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPSessionManager manager];
////////////////////////////////////////////////////////////////////////////////
//    [self.tableView setSectionHeaderHeight:[self getSectionHaderHight] + 120];
    
    
    NSLog(@"%f",[self getSectionHaderHight]);
    [self setView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    view.backgroundColor = [UIColor blackColor];
    self.searchView = view;
    
    
//    [self.tableView addSubview:self.searchView];
    
    
    [self.tableView setTableHeaderView:[self setImageView]];

  
    

}

- (CGFloat )getSectionHaderHight
{
    //    self.messageLable.text = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSString *version = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSLog(@"%@",version);
    NSLog(@"!!!!!!%@",DeviceVersionNames[[SDiOSVersion deviceVersion]]);
  
     if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 170;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 197.5;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 217;
    
    }
        
    return 200;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark ---- 设置HeaderView
- (void)setView
{
    [self setScroView];
    [self setPageControl];
    [self setSearchBar];
}


- (void)setScroView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.tableView.bounds.size.width, [self getSectionHaderHight] +50)];
    
   
    
    self.backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [self getSectionHaderHight] +50)];
    NSLog(@"**********************%f",self.tableView.bounds.size.width);
    NSLog(@"2@@@@@@@@@@@@@@@@@@@@@@%f",[self getSectionHaderHight]);
    
    backView.backgroundColor = [UIColor blackColor];
    
//    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 + [self getSectionHaderHight] +15, self.view.bounds.size.width, 50)];
//    typeView.backgroundColor = [UIColor grayColor];
//    [backView addSubview:typeView];
    
    
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:
                              CGRectMake(0, 50,backView.bounds.size.width,
                                         [self getSectionHaderHight])];
    scroView.contentSize = CGSizeMake(backView.bounds.size.width * 3,
                                      [self getSectionHaderHight]);
    scroView.pagingEnabled = YES;
    scroView.delegate = self;
    scroView.alwaysBounceVertical = NO;
    scroView.alwaysBounceHorizontal = YES;
    scroView.showsVerticalScrollIndicator = FALSE;
    scroView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView = scroView;


    UIView *leftView = [[UIView alloc]initWithFrame:
                        CGRectMake(0, 0,
                                   self.scrollView.bounds.size.width,
                                   [self getSectionHaderHight])];
    leftView.backgroundColor = [UIColor redColor];
    UIView *rightView = [[UIView alloc]initWithFrame:
                         CGRectMake(self.scrollView.bounds.size.width, 0,
                                    self.scrollView.bounds.size.width,
                                    [self getSectionHaderHight])];
    rightView.backgroundColor = [UIColor blueColor];
    UIView *thirdView = [[UIView alloc]initWithFrame:
                         CGRectMake(self.scrollView.bounds.size.width * 2, 0,
                                    self.scrollView.bounds.size.width,
                                    [self getSectionHaderHight])];
    rightView.backgroundColor = [UIColor blueColor];
    
    
    
    [scroView addSubview:leftView];
    [scroView addSubview:rightView];
    [scroView addSubview:thirdView];
    

    self.backView = backView;
    NSLog(@"%f)))))))))))))))))))))1",self.backView.bounds.size.height);

    [self.backView addSubview:scroView];
    [self setButtonWithleftView:leftView];
    [self setButtonWithrightView:rightView];
    [self setButtonWithrthirdView:thirdView];
    NSLog(@"%f)))))))))))))))))))))2",self.backView.bounds.size.height);

    
}

- (void)setSearchBar
{
    SearchBar *searchBar= [[SearchBar alloc]initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 50)];
     self.searchBarbutton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.searchBarbutton.backgroundColor = [UIColor grayColor];
    [self.searchBarbutton setTitle:@"找服务" forState:(UIControlStateNormal)];
    self.searchBarbutton.frame = CGRectMake(0, 0, 80, 50);
    
    searchBar.leftView = self.searchBarbutton;
    self.searchBarbutton.layer.cornerRadius = 10;
    
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.backgroundColor = [UIColor blueColor];
    [self.searchBarbutton addTarget:self action:@selector(searchBarbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
      [self.backView addSubview:searchBar];
    NSLog(@"%f)))))))))))))))))))))3",self.backView.bounds.size.height);
    
}


//按钮点击事件
- (void)searchBarbuttonAction:(UIButton *)searchButton
{
    if ([searchButton.titleLabel.text isEqualToString:@"找服务"]) {
        [searchButton setTitle:@"找信息" forState:(UIControlStateNormal)];
        self.infoType = @"找信息";
        [self findInfomations];
        
    }
    if ([searchButton.titleLabel.text isEqualToString:@"找信息"]) {
        [searchButton setTitle:@"找服务" forState:(UIControlStateNormal)];
        self.infoType = @"找服务";
        [self findService];
    }
    
}
//获取信息的数据
- (void)findInfomations
{
    
    [self.sourceArray removeAllObjects];
    
    NSString *getURL = [FindInformationURL stringByAppendingString:@"?access_token=token"];
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *access_token = @"token";
    
    [getdic setObject:access_token forKey:@"access_token"];
    
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------%@",responseObject);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray) {
            
            self.model = [[PublishModel alloc]init];
            [self.model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:self.model];
            NSLog(@"------------%@",self.sourceArray);
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
}
//获取服务的数据
- (void)findService
{

}



- (void)setPageControl
{      CGPoint pagePoint = CGPointMake(self.view.center.x, [self getSectionHaderHight] +40);
    
     self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height - 10, 80, 10)];
    [self.pageControl setCenter:pagePoint];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 1;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * self.pageControl.currentPage, 0) animated:YES];

    [self.backView addSubview:self.pageControl];
    NSLog(@"%f)))))))))))))))))))))4",self.backView.bounds.size.height);

    [self.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:(UIControlEventValueChanged)];
 }

- (UIView *)setImageView
{
    
    
     self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.backView.bounds.size.height + 200)];
       UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    imageview.image = [UIImage imageNamed:@"lunbotu.jpg"];

    [self.headView addSubview:imageview];
    [self.headView addSubview:self.backView];
    
        return self.headView;
    
}
/////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 200 + self.backView.bounds.size.height) {
        [self.view bringSubviewToFront:self.searchView];
    }
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        NSLog(@"------是列表---");
    }
    else {
        //滑动scrollView后，改变pageControl当前点
        CGPoint contentOffset = scrollView.contentOffset;
        NSInteger currentPage = contentOffset.x / self.view.bounds.size.width;
        //设置self.pageControl的选中点
        [self.pageControl setCurrentPage:currentPage];
        
        NSLog(@"%f(((((((((((((((((((((",self.backView.bounds.size.height);
        
        
        if (currentPage == 0) {
                    [self findInfomations];
            [self.searchBarbutton setTitle:@"找信息" forState:(UIControlStateNormal)];
        }
        else
        {
            [self.searchBarbutton setTitle:@"找服务" forState:(UIControlStateNormal)];

        }
    }
  
}


- (void)pageControlAction:(UIPageControl *)pageControl
{
    NSLog(@"当前选中页数：%ld,%s,%d",pageControl.currentPage, __FUNCTION__,__LINE__);
    //改变self.scrollView的contenOffset
    //    [self.scrollView setContentInset:CGPointMake(self.view.bounds.size.width*pageControl.currentPage,0) animated:YES)];
    
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * pageControl.currentPage, 0) animated:YES];
    
    

}


- (void)setButtonWithleftView:(UIView *)view
{
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 5;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"测试" forState:(UIControlStateNormal)];
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        NSLog(@"___________________________________%f",button.frame.size.height);
        button.tag = i;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [view addSubview:button];
    }
    //设置按钮的图片---图片数组
    for (int i = 1; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10 + Buttonheight + 20,
                    Buttonheight, Buttonheight)];
        button.backgroundColor = [UIColor blackColor];
        [button setTitle:@"测试" forState:(UIControlStateNormal)];
        
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        button.tag = i + 4;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [view addSubview:button];
        
    }
}

- (void)setButtonWithrightView:(UIView *)view
{
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 5;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"测试" forState:(UIControlStateNormal)];
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        button.tag = i + 8;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [view addSubview:button];
    }
    
    for (int i = 1; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10 + Buttonheight + 20,
                    Buttonheight, Buttonheight)];
        button.backgroundColor = [UIColor blackColor];
        [button setTitle:@"测试" forState:(UIControlStateNormal)];
        
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        button.tag = i + 12;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [view addSubview:button];
        
    }
    
    
    
}

- (void)setButtonWithrthirdView:(UIView *)view
{
    
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    
    for(int i = 1;i< 4;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"测试" forState:(UIControlStateNormal)];
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        button.tag = i + 16;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [view addSubview:button];
    }
    
}



- (void)addtatgetWithButtonTag:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            
            NSLog(@"111111");
            break;
        case 2:
            NSLog(@"2");

            break;
        case 3:
            NSLog(@"3");

            break;
        case 4:
            NSLog(@"4");
            break;
        case 5:
            NSLog(@"5");

            break;
        case 6:
            NSLog(@"6");
            break;
        case 7:
            NSLog(@"7");

            break;
        case 8:
            NSLog(@"8");

            break;
        case 9:
            NSLog(@"9");

            break;
        case 10:
            NSLog(@"10");

            break;
        case 11:
            NSLog(@"11");

            break;
        case 12:
            NSLog(@"12");

            break;
        case 13:
            NSLog(@"13");

            break;
        case 14:
            NSLog(@"14");

            break;
        case 15:
            NSLog(@"15");

            break;
        case 16:
            NSLog(@"16");

            break;
        case 17:
            NSLog(@"17");

            break;
        case 18:
            NSLog(@"18");

            break;
        case 19:
            NSLog(@"19");

            break;
        default:
            break;
    }
    
    
    
}







#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return [self getSectionHaderHight] + 120;
        

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

        return self.sourceArray.count;

   

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 82;

}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"ABCD";
//}
//
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
//{
//    return 250;
//    
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    MainSectionHeadView *view = [[MainSectionHeadView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [self getSectionHaderHight])];
    
  
        self.backView2.backgroundColor = [UIColor redColor];
        
        return self.backView2;
        
 

    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 

        PublishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[PublishCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PublishCell"];
        }
        cell.model = self.sourceArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
}
@end
