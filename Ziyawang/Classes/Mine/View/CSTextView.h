//
//  CSTextView.h
//  DaYiQuan
//
//  Created by 崔丰帅 on 16/3/28.
//  Copyright © 2016年 Mr.Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholerColor;
/** 字数统计 */
@property (nonatomic, strong) UILabel *wordLabel;
@end
