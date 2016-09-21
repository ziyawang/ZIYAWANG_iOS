//
//  ScrollHeadView.m
//  customScrollView
//
//  Created by mac on 16/8/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ScrollHeadView.h"
#import "UIScrollView+_DScrollView.h"

@interface ScrollHeadView()<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *arraySource;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIPageControl *pageControl;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,assign)NSInteger lastPage;

@end

@implementation ScrollHeadView


-(instancetype)initWithFrame:(CGRect)frame arraySource:(NSMutableArray *)arraySource{
    
    if (self=[super initWithFrame:frame]) {
        
        _arraySource=arraySource;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createScrollView];
            
        });
    }
    return self;
}

- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    [self addSubview:_scrollView];
    
    if (_arraySource.count == 0 || _arraySource == nil) {
        return;
    }
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*(_arraySource.count), CGRectGetHeight(self.bounds));
    
    
 
    for (int i = 0 ; i<_arraySource.count; i++) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)*i, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        imageV.tag = 100*i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [imageV addGestureRecognizer:tap];
        
        imageV.userInteractionEnabled = YES;
        
        /**
         图片是从网络上加载的
         注意此时数组中存的应该是图片正确的下载网址否则不可用,并且需要导入第三方库(SDWebImage),及其头文件(#import "UIImageView+WebCache.h")否则无法使用网络资源
         [_imageV sd_setImageWithURL:[NSURL URLWithString:array[i]]];
         */
        //本地图片加载的方法
//        imageV.image = [UIImage imageNamed:_arraySource[i]];
    
        
         [imageV sd_setImageWithURL:[NSURL URLWithString:_arraySource[i]]];
        
        [_scrollView addSubview:imageV];
        
    }
//    [_scrollView make3Dscrollview];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.center.x-100, CGRectGetHeight(self.bounds) - 30, 200, 30)];
    _pageControl.numberOfPages = _arraySource.count-2;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pageControl];
    _lastPage = _arraySource.count - 1;
    
    [self timerOn];
}
//该方法是添加的tap事件当点击不同的图片会执行不同的命令
- (void)tap:(UITapGestureRecognizer*)tap{
    
    NSLog(@"%ld",tap.view.tag);
    if (self.Mydelegate != nil && [self.Mydelegate respondsToSelector:@selector(didTapScrollHeadView)]) {
        [self.Mydelegate didTapScrollHeadView];
    }
    
}
#pragma mark -定时器方法
- (void)onTimer
{
    int index = _scrollView.contentOffset.x/CGRectGetWidth(self.bounds);
    index++;
    
    if (index == _lastPage) {
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*_lastPage, 0) animated:YES];
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        _pageControl.currentPage = 0;

    }else{
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*index, 0) animated:YES];
        _pageControl.currentPage = _scrollView.contentOffset.x/CGRectGetWidth(self.bounds);
        
    }
}

#pragma mark -UIPageControl绑定方法
- (void)pageControlClick:(UIPageControl *)sender{
    [_scrollView setContentOffset:CGPointMake((sender.currentPage+1)*CGRectGetWidth(self.bounds), 0) animated:YES];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self timerOff];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x/CGRectGetWidth(self.bounds) == _lastPage) {
        //当显示第7个位置的图片时(第1张图片) _pageControl对应应该显示第0页 滑动视图对应应该移动偏移量到第2个位置的图片(第1张图片)
        _pageControl.currentPage = 0;
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
    }else if(scrollView.contentOffset.x/CGRectGetWidth(self.bounds) == 0){
        _pageControl.currentPage = _lastPage-2;
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*(_lastPage-1), 0)];
    }else{
        _pageControl.currentPage = scrollView.contentOffset.x/CGRectGetWidth(self.bounds)-1;
    }
    [self timerOn];
}

//开启定时器
-(void)timerOn{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}


//关闭定时器
-(void)timerOff{
    
    [_timer invalidate];
    _timer = nil;
}

@end
