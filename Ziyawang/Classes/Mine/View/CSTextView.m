
//
//  CSTextView.m
//  DaYiQuan
//
//  Created by 崔丰帅 on 16/3/28.
//  Copyright © 2016年 Mr.Cui. All rights reserved.
//

#import "CSTextView.h"

@interface CSTextView ()


@end

@implementation CSTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 不要设置自己的delegate为自己
        // self.delegate = self;
        
        // 通知
        //当UItextView的文字发生改变时 UITextView自己会发出UITextFieldTextDidChangeNotification 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
//        [self setupWordLabel];
        
    }
    return self;
}

/**
 *  设置字数统计label
 */
//- (void)setupWordLabel {
//    _wordLabel = [[UILabel alloc] init];
//    _wordLabel.font = [UIFont setFontOfSize:19];
//    _wordLabel.textColor = kGrayColor;
//    _wordLabel.backgroundColor = [UIColor blueColor];
//    _wordLabel.text = @"0/100";
//    _wordLabel.textAlignment = NSTextAlignmentRight;
////    [self addSubview:_wordLabel];
//    
//    _wordLabel.sd_layout
//    .bottomSpaceToView(self, 15 * kHeightScale)
//    .rightSpaceToView(self, 15 * kWidthScale)
//    .heightIs(25 * kHeightScale)
//    .widthIs(100 * kWidthScale);
////    [_wordLabel setSingleLineAutoResizeWithMaxWidth:100 * kWidthScale];
//}

/**
 *  监听文字改变
 */

- (void)textDidChange {
    
    // 重绘
    // setNeedsDisplay 会在下一个消息循环时刻重画drawRect
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
// 画出来
- (void)drawRect:(CGRect)rect {
    // 判断是否有文字 有就直接返回
    if (self.hasText) {
        return;
    }
    
    // 文字的属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholerColor ? self.placeholerColor : [UIColor lightGrayColor];
    // 画文字
    // [self.placeholder drawAtPoint:CGPointMake(5, 10) withAttributes:attrs];
    CGFloat x = 5.0;
    CGFloat w = rect.size.width - 2.0 * x;
    CGFloat y = 10.0;
    CGFloat h = rect.size.height - 2.0* y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholerColor:(UIColor *)placeholerColor {
    if (_placeholerColor != placeholerColor) {
        _placeholerColor = nil;
        _placeholerColor = placeholerColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text {
    
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}



@end
