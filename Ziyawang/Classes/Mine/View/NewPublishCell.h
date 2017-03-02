//
//  NewPublishCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishModel.h"

@interface NewPublishCell : UITableViewCell

@property (nonatomic,strong) NSString *TypeName;
@property (nonatomic,strong) PublishModel *model;
@end
