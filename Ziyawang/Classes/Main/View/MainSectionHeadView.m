//
//  MainSectionHeadView.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/27.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MainSectionHeadView.h"


@interface MainSectionHeadView()<UIScrollViewDelegate>


@end

@implementation MainSectionHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setView];
        
    }
    return self;
}

- (void)setView
{
    [self setScroView];
}


- (void)setScroView
{
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:
                              CGRectMake(0, 30, self.bounds.size.width,
                                         self.bounds.size.height)];
    scroView.contentSize = CGSizeMake(self.bounds.size.width * 3,
                                      self.bounds.size.height);
    scroView.pagingEnabled = YES;
    scroView.delegate = self;
    scroView.alwaysBounceVertical = NO;
    scroView.alwaysBounceHorizontal = YES;
    
    UIView *leftView = [[UIView alloc]initWithFrame:
                        CGRectMake(0, 0,
                                   self.bounds.size.width,
                                   self.bounds.size.height)];
    leftView.backgroundColor = [UIColor redColor];
    UIView *rightView = [[UIView alloc]initWithFrame:
                         CGRectMake(self.bounds.size.width, 0,
                                    self.bounds.size.width,
                                    self.bounds.size.height)];
    rightView.backgroundColor = [UIColor blueColor];
    UIView *thirdView = [[UIView alloc]initWithFrame:
                         CGRectMake(self.bounds.size.width * 2, 0,
                                    self.bounds.size.width,
                                    self.bounds.size.height)];
    rightView.backgroundColor = [UIColor blueColor];
    
    [scroView addSubview:leftView];
    [scroView addSubview:rightView];
    [scroView addSubview:thirdView];
    
    [self addSubview:scroView];
    [self setButtonWithleftView:leftView];
    [self setButtonWithrightView:rightView];
    [self setButtonWithrthirdView:thirdView];
    
//    CGFloat Buttonheight = (self.bounds.size.width - 100) / 4;
//    for(int i = 1;i< 5;i ++)
//    {
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [button setFrame:
//         CGRectMake(20 *i + Buttonheight * (i-1), 10,
//                    Buttonheight, Buttonheight)];
//        button.backgroundColor = [UIColor whiteColor];
//        [button setTitle:@"测试" forState:(UIControlStateNormal)];
//        [leftView addSubview:button];
//        [rightView addSubview:button];
//            }
//    //设置按钮的图片---图片数组
//    for (int i = 1; i < 5; i ++) {
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [button setFrame:
//         CGRectMake(20 *i + Buttonheight * (i-1), 10 + Buttonheight + 20,
//                    Buttonheight, Buttonheight)];
//        button.backgroundColor = [UIColor blackColor];
//        [button setTitle:@"测试" forState:(UIControlStateNormal)];
//
//        [leftView addSubview:button];
//        [rightView addSubview:button];
//
//    }
//
}


- (void)setButtonWithleftView:(UIView *)view
{
    CGFloat Buttonheight = (self.bounds.size.width - 100) / 4;
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
    CGFloat Buttonheight = (self.bounds.size.width - 100) / 4;
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
    
    CGFloat Buttonheight = (self.bounds.size.width - 100) / 4;

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
        button.tag = i + 8;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [view addSubview:button];
    }

}



- (void)addtatgetWithButtonTag:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 10:
            
            break;
        case 11:
            
            break;
        case 12:
            
            break;
        case 14:
            
            break;
        case 15:
            
            break;
        case 16:
            
            break;
        case 17:
            
            break;
        case 18:
            
            break;
        case 19:
            
            break;
        default:
            break;
    }
    
    

}

- (void)setSearchBar
{


}

- (void)setPageControl
{


}
@end
