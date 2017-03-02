//
//  FindView.m
//  Ziyawang
//
//  Created by Mr.Xu on 2017/2/20.
//  Copyright © 2017年 Mr.Xu. All rights reserved.
//

#import "FindView.h"

#define w self.bounds.size.width/3
#define W (self.bounds.size.width - 80)/3
#define h 40
@interface FindView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *chooseTableView;
@property (nonatomic,strong) UIView *segView;
@property (nonatomic,strong) FindButton *button1;
@property (nonatomic,strong) FindButton *button2;
@property (nonatomic,strong) FindButton *button3;

@property (nonatomic,strong) UIView *view1;
@property (nonatomic,strong) UIScrollView *view2;

@property (nonatomic,assign) BOOL ifdown;
@property (nonatomic,assign) BOOL ifdown2;
@property (nonatomic,assign) BOOL ifdown3;

@property (nonatomic,assign) NSInteger dowNum;
@property (nonatomic,strong) UIButton *selectedButton;
@property (nonatomic,strong) UIButton *selectedButton2;

@property (nonatomic,strong) UIView *menbanView;

@property (nonatomic,strong) NSString *chooseType;
@property (nonatomic,strong) NSString *defaultSelectString;
@property (nonatomic,strong) UIButton *defaultButton;
@property (nonatomic,strong) UITableViewCell *selectedCell;
@end

@implementation FindView
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray
{
    self = [[FindView alloc]initWithFrame:frame];
    if (self) {
        self.defaultSelectString = titleArray.lastObject;
        
        [self setViewsWithTitleArray];
    }
    return  self;
}
- (void)setSourArrayOne:(NSArray *)sourArrayOne
{
    if (_sourArrayOne != sourArrayOne) {
        _sourArrayOne = nil;
        _sourArrayOne = sourArrayOne;
        [self buttonView1];
    }
}
- (void)setSourArrayTwo:(NSArray *)sourArrayTwo
{
    if (_sourArrayTwo != sourArrayTwo) {
        _sourArrayTwo = nil;
        _sourArrayTwo = sourArrayTwo;
        [self buttonView2];
    }
}
- (void)setSourArrayThree:(NSArray *)sourArrayThree
{
    if (_sourArrayThree != sourArrayThree) {
        _sourArrayThree = nil;
        _sourArrayThree = sourArrayThree;
        [self buttonView3];
    }
}
- (void)setTitleArray:(NSArray *)titleArray
{
    if (_titleArray != titleArray) {
        _titleArray = nil;
        _titleArray = titleArray;
        [self setTitleForButton];
    
    }
}

- (void)setViewsWithTitleArray
{
    //    [self buttonView1];
    //    [self buttonView2];
    //    [self buttonView3];
    
    //    self.segView = [UIView new];
    //    _button1 = [[FindButton alloc]initWithFrame:CGRectMake(20, 100, w, 40)];
    //    _button2 = [[FindButton alloc]initWithFrame:CGRectMake(40 + w, 100, w, 40)];
    //    _button3 = [[FindButton alloc]initWithFrame:CGRectMake(60 + 2*w, 100, w, 40)];
//    titleArray =
//    self.titleArray;
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    
    self.menbanView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.menbanView.backgroundColor = [UIColor blackColor];
    self.menbanView.alpha = 0.5;
    //    [self addSubview:self.menbanView];
    //    [self.menbanView setHidden:YES];
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mengbanViewGestureAction:)];
    [self.menbanView addGestureRecognizer:gesture];
    
    self.dowNum = 0;
    
    _button1 = [[FindButton alloc]initWithFrame:CGRectMake(0, 0, w, 40) title:_titleArray[0]];
    _button2 = [[FindButton alloc]initWithFrame:CGRectMake(w, 0, w, 40) title:_titleArray[1]];
    _button3 = [[FindButton alloc]initWithFrame:CGRectMake(2*w, 0, w, 40) title:_titleArray[2]];
    
 
    
    
    [_button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_button3 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    _button1.backgroundColor = [UIColor whiteColor];
    _button2.backgroundColor = [UIColor whiteColor];
    _button3.backgroundColor = [UIColor whiteColor];
    
    [_button1 addTarget:self action:@selector(button1Action:) forControlEvents:(UIControlEventTouchUpInside)];
    [_button2 addTarget:self action:@selector(button2Action:) forControlEvents:(UIControlEventTouchUpInside)];
    [_button3 addTarget:self action:@selector(button3Action:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:_button1];
    [self addSubview:_button2];
    [self addSubview:_button3];
}
- (void)setTitleForButton
{
    [_button1 setTitle:_titleArray[0] forState:(UIControlStateNormal)];
    [_button2 setTitle:_titleArray[1] forState:(UIControlStateNormal)];
    [_button3 setTitle:_titleArray[2] forState:(UIControlStateNormal)];
    
    if ([_titleArray[0] isEqualToString:@"信息类型"] || [_titleArray[0] isEqualToString:@"服务类型"] || [_titleArray[0] isEqualToString:@"处置公告"]) {
        [self.button3 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.button3.userInteractionEnabled = NO;
    }
    else
    {
        [self.button3 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        self.button3.userInteractionEnabled = YES;
    }
}
#pragma View 布局
- (void)buttonView1
{
    self.view1 = [[UIView alloc]initWithFrame:CGRectZero];
    self.view1.backgroundColor = [UIColor whiteColor];
    //    CGFloat w = self.bounds.size.width - 60 /3;
    //    CGFloat h = 40;
    for (int i = 0; i < self.sourArrayOne.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        
        [btn setTitle:self.sourArrayOne[i] forState:(UIControlStateNormal)];
        [btn setFrame:CGRectMake(i%3 * W + (i%3+1) * 20, i/3 * h +(i/3+1)*10, W, h)];
        [btn addTarget:self action:@selector(didClickOneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];

        if ([btn.titleLabel.text isEqualToString:self.defaultSelectString]) {
            self.defaultButton = btn;
            [self.defaultButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
            [self.view1 addSubview:self.defaultButton];
        }
        else
        {
     
        [self.view1 addSubview:btn];
        }
    }
    [self.superview addSubview:self.view1];
    [self.view1 setHidden:YES];
}
- (void)buttonView2
{
    self.view2 = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.view2.backgroundColor = [UIColor whiteColor];
    
     self.view2.contentSize = CGSizeMake(self.bounds.size.width, self.sourArrayTwo.count/3 * h + self.sourArrayTwo.count/3*40 + 100);
    self.view2.showsHorizontalScrollIndicator = NO;
    
    //    CGFloat w = self.bounds.size.width - 60 /3;
    //    CGFloat h = 40;
    for (int i = 0; i < self.sourArrayTwo.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btn.backgroundColor = [UIColor whiteColor];
        
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btn setTitle:self.sourArrayTwo[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [btn setFrame:CGRectMake(i%3 * W + (i%3+1) * 20, i/3 * h +(i/3+1)*10, W, h)];
        [btn addTarget:self action:@selector(didClickTowButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view2 addSubview:btn];
    }
    [self.superview addSubview:self.view2];
    [self.view2 setHidden:YES];
    
}
- (void)buttonView3
{
    self.chooseTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    [self.superview addSubview:self.chooseTableView];
    //    self.chooseTableView.backgroundColor = [UIColor greenColor];
    [self.chooseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.chooseTableView.delegate = self;
    self.chooseTableView.dataSource = self;
//    [self.chooseTableView setSectionHeaderHeight:30];
//    self.chooseTableView.sectionHeaderHeight = 30;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 0.1)];
    view.backgroundColor = [UIColor whiteColor];
    [self.chooseTableView setTableHeaderView:view];

    
//    [self.chooseTableView.tableHeaderView setHeight:0];
    self.chooseTableView.backgroundColor = [UIColor whiteColor];
    
   
//    self.chooseTableView.sectionHeaderHeight = 10;
    NSDictionary *dic1 = _sourArrayThree[0];
    NSDictionary *dic2 = [NSDictionary new];
    NSArray *array1 = dic1[@"data"];
    NSArray *array2 = [NSArray new];
    
    if (self.sourArrayThree.count > 2) {
        dic2 = self.sourArrayThree[1];
        array2 = dic2[@"data"];
        [self.chooseTableView reloadData];
    }
        [self.chooseTableView reloadData];
    
    //    [UIView animateWithDuration:0.5 animations:^{
    //        [self.chooseTableView setFrame:CGRectMake(0, 40, self.bounds.size.width, (array1.count + array2.count)*44 )];
    //    }];
    
}
- (void)addMengbanViewWithView:(UIView *)view
{
    [self.menbanView setHidden:NO];
    [self.superview addSubview:self.menbanView];
    [self.superview bringSubviewToFront:self];
    [self.superview bringSubviewToFront:view];
    UIView *mView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.superview addSubview:mView];
}

-(void)removeMengbanView
{
    [self.menbanView removeFromSuperview];
}
#pragma mark----按钮点击事件
- (void)button1Action:(FindButton *)sender
{
    
    [self.selectedButton2 setBackgroundColor:[UIColor whiteColor]];
    self.selectedButton2 = [UIButton new];
    
    switch (self.dowNum) {
        case 0:
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self.view1 setHidden:NO];
                [self.view1 setFrame:CGRectMake(0, 40, self.bounds.size.width, self.sourArrayOne.count/3 * h + self.sourArrayOne.count/3*40)];
                self.dowNum = 1;
            }];
            [self addMengbanViewWithView:self.view1];
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self.view1 setHidden:YES];
                [self.view1 setFrame:CGRectZero];
                self.dowNum = 0;
            }];
            [self removeMengbanView];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self.view2 setHidden:YES];
                [self.view2 setFrame:CGRectZero];
                
                [self.view1 setHidden:NO];
                [self.view1 setFrame:CGRectMake(0, 40, self.bounds.size.width, self.sourArrayOne.count/3 * h + self.sourArrayOne.count/3*40)];
                self.dowNum = 1;
            }];
            [self addMengbanViewWithView:self.view1];
        }
            break;
        case 3:
        {
            [UIView animateWithDuration:0.1 animations:^{
                //                [self.chooseTableView setHidden:YES];
                [self.chooseTableView setFrame:CGRectZero];
                
                [self.view1 setHidden:NO];
                [self.view1 setFrame:CGRectMake(0, 40, self.bounds.size.width, self.sourArrayOne.count/3 * h + self.sourArrayOne.count/3*40)];
                self.dowNum = 1;
            }];
            [self addMengbanViewWithView:self.view1];
        }
            break;
        default:
            break;
    }
    //    if (self.ifdown == YES) {
    //        [UIView animateWithDuration:0.5 animations:^{
    //            [self.view1 setHidden:YES];
    //            [self.view1 setFrame:CGRectZero];
    //            self.ifdown = NO;
    //        }];
    //    }
    //    else
    //    {
    //            }
}
- (void)button2Action:(FindButton *)sender
{
    //    [self.menbanView setHidden:NO];
    //    [self.superview addSubview:self.menbanView];
    //    [self.superview bringSubviewToFront:self.view2];
    //    [self.superview bringSubviewToFront:self];
    //    NSLog(@"2");
    //
    //[UIView animateWithDuration:0.5 animations:^{
    //        [self.view2 setHidden:NO];
    //        [self.view2 setFrame:CGRectMake(0, 40, self.bounds.size.width, self.sourArrayTwo.count/3 * h + 20)];
    //    }];
    switch (self.dowNum) {
        case 0:
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self.view2 setHidden:NO];
                [self.view2 setFrame:CGRectMake(0, 40, self.bounds.size.width, self.sourArrayTwo.count/3 * h + self.sourArrayTwo.count/3*40)];
               
                
                self.dowNum = 2;
            }];
            [self addMengbanViewWithView:self.view2];
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self.view1 setHidden:YES];
                [self.view1 setFrame:CGRectZero];
                
                [self.view2 setHidden:NO];
                [self.view2 setFrame:CGRectMake(0, 40, self.bounds.size.width, self.sourArrayTwo.count/3 * h + self.sourArrayTwo.count/3*40)];
                self.dowNum = 2;
            }];
            [self addMengbanViewWithView:self.view2];
            
        }
            break;
        case 2:
        {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                [self.view2 setFrame:CGRectZero];
                [self.view2 setHidden:YES];
                
                self.dowNum = 0;
                
            }];
            [self removeMengbanView];
        }
            break;
        case 3:
        {
            [UIView animateWithDuration:0.1 animations:^{
                //                [self.chooseTableView setHidden:YES];
                [self.chooseTableView setFrame:CGRectZero];
                [self.view2 setHidden:NO];
                
                [self.view2 setFrame:CGRectMake(0, 40, self.bounds.size.width, self.sourArrayTwo.count/3 * h + self.sourArrayTwo.count/3*40)];
                
                self.dowNum = 2;
            }];
            [self addMengbanViewWithView:self.view2];
            
        }
            break;
        default:
            break;
    }
    
}
- (void)button3Action:(FindButton *)sender
{
    
    NSLog(@"3");
//    [self.superview addSubview:self.menbanView];
//    [self.superview bringSubviewToFront:self.self.chooseTableView];
//    [self.superview bringSubviewToFront:self];
    NSDictionary *dic1 = self.sourArrayThree[0];
    NSDictionary *dic2 = [NSDictionary new];
    NSArray *array1 = dic1[@"data"];
    NSArray *array2 = [NSArray new];
    
    if (self.sourArrayThree.count > 1) {
        array2 = self.sourArrayThree[1][@"data"];
    }
    NSLog(@"%ld",array1.count + array2.count);
    
    
    switch (self.dowNum) {
        case 0:
        {
                        [self.chooseTableView setHidden:NO];
            [UIView animateWithDuration:0.1 animations:^{
                
                [self.chooseTableView setFrame:CGRectMake(0, 40, self.bounds.size.width, (array1.count + array2.count)*44 +self.sourArrayThree.count *35)];
                self.dowNum = 3;
            }];
            [self addMengbanViewWithView:self.chooseTableView];
        }
            break;
        case 1:
        {
            [self.view1 setHidden:YES];
            [self.view1 setFrame:CGRectZero];
            
            //            [self.chooseTableView setHidden:NO];
            [UIView animateWithDuration:0.1 animations:^{
                [self.chooseTableView setHidden:NO];
                
                [self.chooseTableView setFrame:CGRectMake(0, 40, self.bounds.size.width, (array1.count + array2.count)*44 +self.sourArrayThree.count *35)];
                self.dowNum = 3;
            }];
            [self addMengbanViewWithView:self.chooseTableView];
        }
            break;
        case 2:
        {
            [self.view2 setHidden:YES];
            [self.view2 setFrame:CGRectZero];
            [self.chooseTableView setHidden:NO];
            [UIView animateWithDuration:0.1 animations:^{
                
                [self.chooseTableView setFrame:CGRectMake(0, 40, self.bounds.size.width, (array1.count + array2.count)*44 +self.sourArrayThree.count *35)];
                self.dowNum = 3;
            }];
            [self addMengbanViewWithView:self.chooseTableView];
        }
            break;
        case 3:
        {
            [UIView animateWithDuration:0.1 animations:^{
                //            [self.chooseTableView setHidden:YES];
                [self.chooseTableView setFrame:CGRectZero];
                self.dowNum = 0;
            }];
            [self removeMengbanView];
        }
            break;
            
        default:
            break;
    }
//    self.chooseTableView.contentInset = UIEdgeInsetsMake(30, 0, 20, 0);
    
//    [self.chooseTableView setContentOffset:CGPointMake(0,0) animated:NO];
//    [self.chooseTableView reloadData];
    //    [UIView animateWithDuration:0.5 animations:^{
    //
    //        [self.chooseTableView setFrame:CGRectMake(0, 40, self.bounds.size.width, (array1.count + array2.count)*44 +100 )];
    //    }];
}
- (void)didClickOneButtonAction:(UIButton *)button
{
    [self.chooseTableView reloadData];
    [self.defaultButton setBackgroundColor:[UIColor whiteColor]];

    self.chooseType = button.titleLabel.text;
    
    [self.menbanView removeFromSuperview];
    [self.button1 setTitle:button.titleLabel.text forState:(UIControlStateNormal)];
    if ([button.titleLabel.text isEqualToString:@"处置公告"]) {
        self.button2.userInteractionEnabled = NO;
        [self.button2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.button3.userInteractionEnabled = NO;
        [self.button3 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    }
    else
    {
        self.button2.selected = YES;
        [self.button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        self.button3.selected = YES;
        [self.button3 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    
    if (button == self.selectedButton)
    {
    }
    else
    {
        [button setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
        self.selectedButton.backgroundColor = [UIColor whiteColor];
    }
    self.selectedButton = button;
    self.strblock1(button.titleLabel.text);
    [UIView animateWithDuration:0.1 animations:^{
        
        [self.view1 setHidden:YES];
        [self.view1 setFrame:CGRectZero];
        self.dowNum = 0;
    }];
    [self.menbanView setHidden:YES];
}
- (void)didClickTowButtonAction:(UIButton *)button
{
    [self.menbanView removeFromSuperview];
    [self.button2 setTitle:button.titleLabel.text forState:(UIControlStateNormal)];

    if (button == self.selectedButton2)
    {
        
    }
    else
    {
        [button setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
        self.selectedButton2.backgroundColor = [UIColor whiteColor];
    }
    self.selectedButton2 = button;
    self.strblock2(button.titleLabel.text);
    [UIView animateWithDuration:0.1 animations:^{
        
        [self.view2 setHidden:YES];
        [self.view2 setFrame:CGRectZero];
        self.dowNum = 0;
    }];
    [self.menbanView setHidden:YES];
}
- (void)mengbanViewGestureAction:(UITapGestureRecognizer *)gesture
{
    NSLog(@"手势");
    [self.menbanView removeFromSuperview];
    switch (self.dowNum) {
        case 1:
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self.view1 setHidden:YES];
            }];
            
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self.view2 setHidden:YES];
            }];
        }
            break;
        case 3:
        {
            [UIView animateWithDuration:0.1 animations:^{
                [self.chooseTableView setFrame:CGRectZero];
            }];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark----判断谁打开
- (void)ifDown
{
    
}
#pragma mark----tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.sourArrayThree[0][@"data"][indexPath.row];
        
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = self.sourArrayThree[1][@"data"][indexPath.row];
        
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self.menbanView removeFromSuperview];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.selectedCell)
    {
        
    }
    else
    {
        self.selectedCell.imageView.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];
        cell.imageView.image = [UIImage imageNamed:@"leixingxuanzhong"];
        self.selectedCell = cell;
    }
    
    self.strblock3(cell.textLabel.text,[NSString stringWithFormat:@"%ld",indexPath.section]);
    
    [self.button3 setTitle:cell.textLabel.text forState:(UIControlStateNormal)];
    [UIView animateWithDuration:0.1 animations:^{
        
        [self.chooseTableView setFrame:CGRectZero];
        self.dowNum = 0;
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sourArrayThree.count < 2) {
        return 1;
    }
    else
    {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr1 = self.sourArrayThree[0][@"data"];
    
    if (section == 0) {
        return arr1.count;
    }
    else
    {
        NSArray *arr2 = self.sourArrayThree[1][@"data"];
        
        return arr2.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return self.sourArrayThree[0][@"title"];
//    }
//    else
//    {
//        return self.sourArrayThree[1][@"title"];
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 100;
//    }
//    else
//    {
//        return 100;
//    }
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20)];
//    [view addSubview:label];
//    label.text = @"dsjfiosdh";
    
    static NSString * identy = @"head";
    UITableViewHeaderFooterView * hf = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    if (section == 0)
    
    {
        
       
            NSLog(@"%li",section);
            hf = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identy];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width,30)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 20)];
            [view addSubview:label];
            label.textColor = [UIColor grayColor];
            label.text = self.sourArrayThree[0][@"title"];
            [hf addSubview:view];
        

    }
    
        else
        {
      
                
        hf = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identy];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width,30)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 20)];
            [view addSubview:label];
            label.textColor = [UIColor grayColor];
            label.text = self.sourArrayThree[1][@"title"];
            [hf addSubview:view];
        }

    return hf;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    return view;
}
@end
