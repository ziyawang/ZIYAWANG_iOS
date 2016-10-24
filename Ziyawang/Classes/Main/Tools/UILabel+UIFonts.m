//
//  UILabel+UIFonts.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/10/19.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "UILabel+UIFonts.h"

@implementation UILabel (UIFonts)
+ (void)setFontDistanceWithLabel:(UILabel *)label Font:(UIFont *)font
{
    NSDictionary *dic = @{NSKernAttributeName:@2.0f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:label.text attributes:dic];
    label.attributedText = attributeStr;
}
@end
