//
//  LinkpageController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/28.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "LinkpageController.h"

@interface LinkpageController ()<UIScrollViewDelegate>
//按页滚动的scrollView
@property(nonatomic,retain)UIScrollView *scrollView;
// pageControl
@property (nonatomic,retain)UIPageControl *pageControl;

@property (nonatomic,assign) CGPoint contentoffSet;

@end

@implementation LinkpageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutScrollView];
    
    //后设置pageControl
    
    [self layoutPageControl];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutScrollView
{
    //1、创建UIScrollView与屏幕大小一致
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    //2、设置contentSize高度与屏幕相同，宽度是屏幕宽度的6倍
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*4, self.view.bounds.size.height);
    //设置UIScrollView的pageEnabled属性
    self.scrollView.pagingEnabled = YES;
    //设置UIScrollView代理
    self.scrollView.delegate = self;
    //循环创建UIImageView,添加到scrollView上
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for(int i=1;i<5;i++)
    {
        NSString *name = [NSString stringWithFormat:@"pic0%d",i];
        //创建图片对象
        UIImage *image = [UIImage imageNamed:name];
        //创建ImageView，位置依次向右
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width *(i-1), 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        //添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.scrollView addGestureRecognizer:tapGesture];
        
        
        //设置imageView展示图片的对象
        imageView.image = image;
                //添加到scrollView
        [self.scrollView addSubview:imageView];
        //scrollView 添加到父视图
        [self.view addSubview:self.scrollView];
        
    }
}

#pragma mark---UIScorllViewDelegate
//动画效果结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //滑动scrollView后，改变pageControl当前点
    CGPoint contentOffset = scrollView.contentOffset;
    NSInteger currentPage = contentOffset.x / self.view.bounds.size.width;
    
    //设置self.pageControl的选中点
    [self.pageControl setCurrentPage:currentPage];
    
    
}


-(void)layoutPageControl
{
    //1、创建UIPageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, 620, 335, 47)];
    
    CGPoint point = CGPointMake(self.view.center.x, self.view.bounds.size.height - 20);
    
    [self.pageControl setCenter:point];
    
    //2、设置
    //设置pageControl页的总数
    self.pageControl.numberOfPages = 4;
    
    //设置当前选中页数
    self.pageControl.currentPage = 0;
    //设置选中的颜色
    self.pageControl.currentPageIndicatorTintColor =[UIColor lightGrayColor];
    
    //设置其他点的颜色
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    
    //3、添加到父视图
    [self.view addSubview:self.pageControl];
    
    //4、添加target action
    
    [self.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)pageControlAction:(UIPageControl *)pageControl
{
    NSLog(@"当前选中页数：%ld,%s,%d",pageControl.currentPage, __FUNCTION__,__LINE__);
    //改变self.scrollView的contenOffset
    //    [self.scrollView setContentInset:CGPointMake(self.view.bounds.size.width*pageControl.currentPage,0) animated:YES)];
    
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * pageControl.currentPage, 0) animated:YES];
    self.contentoffSet = self.scrollView.contentOffset;
    
    
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.pageControl.currentPage == 3) {
        [self presentViewController:self.controller animated:YES completion:nil];
    }

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"出碰了");
   
    if (self.contentoffSet.x == self.view.bounds.size.width*3) {
        
        
        [self presentViewController:self.controller animated:YES completion:nil];
        
    }

}

@end
