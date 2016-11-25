//
//  chooseView.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/22.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "chooseView.h"

@implementation chooseView

-(id)init
{
if(self = [super init])
{

}
    return self;
    
}

+(id)initViewWithString:(NSString *)string
{
    chooseView *view = [[chooseView alloc]initWithString:string];
    return view;
    
}
+ (id)initViewWithStringOne:(NSString *)string Label:(UILabel *)label2
{
    chooseView *view = [[chooseView alloc]initWithString:string Label:(UILabel *)label2];
    return view;
}

+ (id)initWithStingOne:(NSString *)stringOne StringTwo:(NSString *)stringTwo placeHolder:(NSString *)placeHolder textField:(UITextField *)textField
{
    chooseView *view = [[chooseView alloc]initWithStringOne:stringOne stringTwo:stringTwo placeHolder:placeHolder textField:textField];
    return view;
    
}

- (id)initWithString:(NSString *)string
{
    if (self = [super init]) {
        UILabel *label1 = [UILabel new];
        [self addSubview:label1];
        label1.sd_layout.leftSpaceToView(self,15)
        .centerYEqualToView(self);
        [label1 setSingleLineAutoResizeWithMaxWidth:200];
        label1.text = string;
    }
    return self;
}
- (id)initWithString:(NSString *)string Label:(UILabel *)label2
{
    if (self = [super init]) {
        UILabel *label1 = [UILabel new];
        label2 = [UILabel new];
        UIImageView *image = [UIImageView new];
        
        [self addSubview:label1];
        [self addSubview:label2];
        [self addSubview:image];
        
        label1.sd_layout.leftSpaceToView(self,15)
        .centerYEqualToView(self);
        [label1 setSingleLineAutoResizeWithMaxWidth:200];
        
        image.sd_layout.rightSpaceToView(self,15)
        .centerYEqualToView(self)
        .heightIs(10)
        .widthIs(20);
        
        image.image = [UIImage imageNamed:@"xiajiantou"];
        
        label2.sd_layout.rightSpaceToView(image,15)
        .centerYEqualToView(self);
        [label2 setSingleLineAutoResizeWithMaxWidth:200];
        label2.text = @"请选择";
        label2.textColor = [UIColor lightGrayColor];
        
        label1.text = string;

    }
        return self;
    
    

}
- (instancetype)initWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo placeHolder:(NSString *)placeHolder textField:(UITextField *)textField
{
    UILabel *label1 = [UILabel new];
    textField = [UITextField new];
    UILabel *label2 = [UILabel new];
    
    [self addSubview:label1];
    [self addSubview:textField];
    [self addSubview:label2];
    
    
    label1.sd_layout.leftSpaceToView(self,15)
    .centerYEqualToView(self);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label2.sd_layout.rightSpaceToView(self,15)
    .centerYEqualToView(self);
    [label2 setSingleLineAutoResizeWithMaxWidth:100];
    
    textField.sd_layout.rightSpaceToView(label2,15)
    .centerYEqualToView(label2)
    .heightIs(40)
    .widthIs(250);
    
    label1.text = stringOne;
    label2.text = stringTwo;
    
    textField.placeholder = placeHolder;
    
    return self;
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
