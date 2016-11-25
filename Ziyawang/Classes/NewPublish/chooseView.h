//
//  chooseView.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/22.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chooseView : UIView
- (id)init;
- (id)initWithString:(NSString *)string;
- (id)initWithString:(NSString *)string Label:(UILabel *)label2;

+ (id)initViewWithStringOne:(NSString *)string Label:(UILabel *)label2;

+ (id)initWithStingOne:(NSString *)stringOne StringTwo:(NSString *)stringTwo placeHolder:(NSString *)placeHolder textField:(UITextField *)textField;

+ (id)initViewWithString:(NSString *)string;

@end
