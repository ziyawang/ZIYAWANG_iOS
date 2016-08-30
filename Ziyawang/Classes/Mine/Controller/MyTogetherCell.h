//
 //  MyTogetherCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/6.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishModel.h"
@interface MyTogetherCell : UITableViewCell
@property (nonatomic,strong)PublishModel *model;
@property (weak, nonatomic) IBOutlet UIButton *cancelOperationButton;
@property (nonatomic,strong) NSString *ProjectID;


@end
