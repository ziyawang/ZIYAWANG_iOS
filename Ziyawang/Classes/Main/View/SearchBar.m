//
//  SearchBar.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/28.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//        UIImageView *searchIcon = [[UIImageView alloc]init];
//        searchIcon.image = [UIImage imageNamed:@""];
//        searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        searchIcon.contentMode = UIViewContentModeCenter;//设置图片居中
        
 
        self.font = [UIFont systemFontOfSize:15];
//        self.placeholder = @"请输入搜索内容";
        self.borderStyle = UITextBorderStyleRoundedRect;
        
        
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc]init];
    
}

@end
