//
//  TextFieldViewAnimate.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "TextFieldViewAnimate.h"

@implementation TextFieldViewAnimate
+ (void)textFieldAnimateWithView:(UIView *)view up:(BOOL)up
{
    const int movementDistance = 250;
    int movenment = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.50];
    view.frame = CGRectOffset(view.frame, 0, movenment);
    [UIView commitAnimations];

}
@end
