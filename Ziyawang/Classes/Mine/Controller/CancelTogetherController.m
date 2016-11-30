//
//  CancelTogetherController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CancelTogetherController.h"
#import "NewPublishCell.h"
@interface CancelTogetherController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *sourceArray;
@end

@implementation CancelTogetherController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height ) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPublishCell" bundle:nil] forCellReuseIdentifier:@"NewPublishCell"];

    self.sourceArray = [NSMutableArray array];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.sourceArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//     *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
//    return cell;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
