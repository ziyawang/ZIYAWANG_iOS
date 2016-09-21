//
//  PushChooseController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/2.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PushChooseController.h"
#import "PushStartController.h"

@interface PushChooseController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *typeText;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation PushChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",self.soucreArray);
    self.dataArray = [NSMutableArray new];
    if ([self.touqixian isEqualToString:@"投资期限"]) {
        for (NSString *str in self.soucreArray) {
           NSString *Str = [str stringByAppendingString:@"年"];
            [self.dataArray addObject:Str];
        }
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.soucreArray.count * 44 ) style:(UITableViewStylePlain)];
    self.tableView.scrollEnabled = NO;
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0 );
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(didclickLeftButton:)];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton addTarget:self action:@selector(didclickLeftButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *buttonimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6, 10, 18)];
    buttonimage.image = [UIImage imageNamed:@"back3"];
    UILabel *buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 30, 20)];
    buttonLabel.text = @"返回";
    buttonLabel.font = [UIFont systemFontOfSize:15];
    
    [leftButton addSubview:buttonimage];
    [leftButton addSubview:buttonLabel];
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbutton;
  }

- (void)didclickLeftButton:(UIBarButtonItem *)leftBarButton
{
    PushStartController *pushStartVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    pushStartVC.lableText =self.typeText;
    pushStartVC.str = self.selectCell;
    
    [self.navigationController popToViewController:pushStartVC animated:YES];
  }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.soucreArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    if([self.touqixian isEqualToString:@"投资期限"])
    {
    cell.textLabel.text = self.dataArray[indexPath.row];
    }
    else
    {
        cell.textLabel.text = self.soucreArray[indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.typeText = self.soucreArray[indexPath.row];
    [defaults setObject:self.typeText forKey:self.selectCell];
    
//    NSIndexPath *index1 =[NSIndexPath indexPathForRow:0 inSection:0];
//    NSIndexPath *index2 =[NSIndexPath indexPathForRow:1 inSection:0];
//    NSIndexPath *index3 =[NSIndexPath indexPathForRow:2 inSection:0];
//    NSIndexPath *index4 =[NSIndexPath indexPathForRow:3 inSection:0];
//    NSIndexPath *index5 =[NSIndexPath indexPathForRow:4 inSection:0];
//
//    UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:index1];
//    UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:index2];
//    UITableViewCell *cell3 = [tableView cellForRowAtIndexPath:index3];
//    UITableViewCell *cell4 = [tableView cellForRowAtIndexPath:index4];
//    UITableViewCell *cell5 = [tableView cellForRowAtIndexPath:index5];
    



    
    
//    switch (indexPath.row) {
//        case 0:
//
//            self.typeText = cell1.textLabel.text;
//            [defaults setObject:self.typeText forKey:self.selectCell];
//            [cell1.imageView setHidden:NO];
//            [cell1.imageView setImage:[UIImage imageNamed:@"tiaolixuanzhong"]];
//            [cell2.imageView setHidden:YES];
//            [cell3.imageView setHidden:YES];
//            [cell4.imageView setHidden:YES];
//            [cell5.imageView setHidden:YES];
//            NSLog(@"点击了第1个");
//         
//            break;
//        case 1:
//            self.typeText = cell2.textLabel.text;
//            [defaults setObject:self.typeText forKey:self.selectCell];
//            [cell2.imageView setHidden:NO];
//            cell2.imageView.image = [UIImage imageNamed:@"tiaolixuanzhong"];
//            [cell1.imageView setHidden:YES];
//            [cell3.imageView setHidden:YES];
//            [cell4.imageView setHidden:YES];
//            [cell5.imageView setHidden:YES];
//            NSLog(@"点击了第2个");
//
//            break;
//        case 2:
//            self.typeText = cell3.textLabel.text;
//            [defaults setObject:self.typeText forKey:self.selectCell];
//
//
//            [cell3.imageView setHidden:NO];
//
//            cell3.imageView.image = [UIImage imageNamed:@"tiaolixuanzhong"];
//            [cell1.imageView setHidden:YES];
//            [cell2.imageView setHidden:YES];
//            [cell4.imageView setHidden:YES];
//            [cell5.imageView setHidden:YES];
//            NSLog(@"点击了第3个");
//
//            break;
//        case 3:
//            self.typeText = cell4.textLabel.text;
//            [defaults setObject:self.typeText forKey:self.selectCell];
//
//
//            [cell4.imageView setHidden:NO];
//
//            cell4.imageView.image = [UIImage imageNamed:@"tiaolixuanzhong"];
//            [cell1.imageView setHidden:YES];
//            [cell2.imageView setHidden:YES];
//            [cell3.imageView setHidden:YES];
//            [cell5.imageView setHidden:YES];
//            NSLog(@"点击了第4个");
//
//            break;
//        case 4:
//            self.typeText = cell5.textLabel.text;
//            [defaults setObject:self.typeText forKey:self.selectCell];
//
//
//            [cell5.imageView setHidden:NO];
//
//            cell5.imageView.image = [UIImage imageNamed:@"tiaolixuanzhong"];
//            [cell1.imageView setHidden:YES];
//            [cell2.imageView setHidden:YES];
//            [cell3.imageView setHidden:YES];
//            [cell4.imageView setHidden:YES];
//            NSLog(@"点击了第5个");
//
//            break;
//        default:
//            break;
//    }
//    [defaults setObject:self.typeText forKey:self.selectCell];
    NSString *str = [defaults objectForKey:@"0"];
   [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"+++++++++++++++++++++++%@",str);
  }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
