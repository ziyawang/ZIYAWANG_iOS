//
//  CheckTextFieldAndLabelText.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CheckTextFieldAndLabelText.h"

@implementation CheckTextFieldAndLabelText
+(BOOL)checkLabelTextWithLabel:(UILabel *)label
{
    if ([label.text isEqualToString:@"请选择"]) {
        return NO;
    }
    else
    {
        return YES;
    }
}

+(BOOL)checkTextFieldTextWithTextField:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]||textField.text == nil) {
        return NO;
    }
    else
    {
        return YES;
    }
}
@end
