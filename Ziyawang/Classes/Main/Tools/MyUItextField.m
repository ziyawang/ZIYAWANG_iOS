//
//  MyUItextField.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/24.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MyUItextField.h"

@implementation MyUItextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
//[super drawPlaceholderInRect:CGRectMake(self.bounds.size.width-130, 10, 130, 15)];
    if ([self.text isEqualToString:@"请输入金额"]) {
        [super drawPlaceholderInRect:CGRectMake(self.bounds.size.width-120, 10, 120, 44)];
    }
    else if([self.text isEqualToString:@"可输入具体价格"])
    {
        
        [super drawPlaceholderInRect:CGRectMake(self.bounds.size.width-150, 10, 150, 44)];
        
    }
    else
    {
        [super drawPlaceholderInRect:rect];
        
    }

}

@end
