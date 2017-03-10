//
//  FindButton.m
//  Ziyawang
//
//  Created by Mr.Xu on 2017/2/21.
//  Copyright © 2017年 Mr.Xu. All rights reserved.
//

#import "FindButton.h"

@implementation FindButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.imgView = [[UIImageView alloc]init];
//        [self addSubview:self.imgView];
//
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [FindButton buttonWithType:(UIButtonTypeCustom)];
    self.frame = frame;
    
    self.imgView = [[UIImageView alloc]init];
    [self addSubview:self.imgView];
    
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    CGFloat button_width = self.frame.size.width;
    CGFloat button_height = CGRectGetHeight(self.frame);
    
    
    self.imgView.frame = CGRectMake(button_width * 6 / 7 - 10 - 1, 0, 15, 8);
    
    self.titleLabel.frame = CGRectMake(0 , 0, button_width - (button_width / 7 + 3 + 1), button_height);
    
    
    CGPoint imageViewCenter = self.imgView.center;
    imageViewCenter.y = button_height / 2;
    self.imgView.center = imageViewCenter;
    self.imgView.image = [UIImage imageNamed:@"箭头向下"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}



@end
