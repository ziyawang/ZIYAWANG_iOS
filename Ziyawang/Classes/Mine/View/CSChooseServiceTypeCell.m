//
//  CSChooseServiceTypeCell.m
//  Ziyawang
//
//  Created by 崔丰帅 on 16/8/9.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CSChooseServiceTypeCell.h"

#define kWidthScale ([UIScreen mainScreen].bounds.size.width/414)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/736)

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CSChooseServiceTypeCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL ifselected;
@property (nonatomic, strong) UIImageView *imageview;


@end

@implementation CSChooseServiceTypeCell

#pragma mark - 懒加载

#pragma mark - 初始化方法

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubViews {
    
//    _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//  
//    [_chooseBtn setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"] forState:UIControlStateNormal];
////    [_chooseBtn setImage:[UIImage imageNamed:@"leixingxuanzhong"] forState:UIControlStateSelected];
//    
//    [_chooseBtn addTarget:self action:@selector(didClickChooseButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    _chooseBtn.frame = CGRectMake(20 * kWidthScale, 5 * kHeightScale, 40 * kWidthScale, 40 * kWidthScale);
//    [self.contentView addSubview:_chooseBtn];
    
    
    _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20 * kWidthScale, 15 * kHeightScale, 20 * kWidthScale, 20 * kWidthScale)];
    _imageview.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];
    [self.contentView addSubview:_imageview];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.text = @"sdfsdsdaf";
    _titleLabel.frame = CGRectMake(80 * kWidthScale, 0, 300 * kWidthScale, 50 * kHeightScale);
    [self.contentView addSubview:_titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    lineView.frame = CGRectMake(0, 50 * kHeightScale, kScreenWidth, 1);
    [self.contentView addSubview:lineView];
    
}

- (void)didClickChooseButtonAction:(UIButton*)button
{
//    if (button.selected == NO) {
//        [button setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [button setImage:[UIImage imageNamed:@"leixingxuanzhong"] forState:UIControlStateNormal];
//    }
}

- (void)laoutImageView
{
    
    if (self.ifselected == YES) {
//        [_chooseBtn setImage:[UIImage imageNamed:@"leixingxuanzhong"] forState:UIControlStateSelected];
        _imageview.image = [UIImage imageNamed:@"leixingxuanzhong"];

    }
    else
    {
//    [_chooseBtn setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"] forState:UIControlStateNormal];
        _imageview.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];
    }
    
}
#pragma mark - 子控件布局

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - getter setter方法
- (void)setModel:(CSChooseServiceTypeModel *)model {
    _titleLabel.text = model.title;
    _chooseBtn.selected = model.chooseStatue;
    self.ifselected = model.chooseStatue;
    
    [self laoutImageView];
}
#pragma mark - 其他方法

@end
