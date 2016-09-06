//
//  PushStartViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/1.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PushStartViewCell.h"
#import "MyUItextField.h"
@interface PushStartViewCell()<UITextFieldDelegate>
@property (nonatomic,strong) NSString *forType;


@end


@implementation PushStartViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        
    }
    return self;
}


- (void)setTextName:(NSString *)textName
{
    if (_textName != textName)
    {
        _textName = nil;

     _textName = textName;
        self.forType = @"Text";
            [self setCell];
    }
    
    
    }

//- (void)setTypeName:(NSString *)typeName
//{
//    if (_typeName != typeName) {
//        _typeName = nil;
//        _typeName = typeName;
//        self.forType = @"Type";
//        [self setCell];
//    }
//}

- (void)setLableText:(NSString *)LableText
{
    if (_LableText != LableText) {
        _LableText = nil;
        _LableText = LableText;
        [self setLable];
    }
}

- (void)setCell
{
    
    self.textLabel.font = [UIFont systemFontOfSize:14];
    
    NSLog(@"@@@@@@@@@@@@@@@%@",self.textName);
//    if ([self.textName isEqualToString:@"来源"] || [self.textName isEqualToString:@"资产包类型"] || [self.textName isEqualToString:@"地区"]) {
//        self.textLabel.text = self.textName;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 100, 10, 70, 20)];
//        
//        lable.font = [UIFont systemFontOfSize:14];
//        
//         if ([self.textName isEqualToString:@"来源"] || [self.textName isEqualToString:@"资产包类型"] || [self.textName isEqualToString:@"地区"])
//         {
//        lable.text = @"请选择";
//             [self.contentView addSubview:lable];
//             
//         }
//    }
    
    
    self.textLabel.text = self.textName;
    if([self.textName isEqualToString:@"总金额"] || [self.textName isEqualToString:@"转让价"] || [self.textName isEqualToString:@"金额"] || [self.textName isEqualToString:@"合同金额"] || [self.textName isEqualToString:@"回报率"]||[self.textName isEqualToString:@"悬赏金额"])
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:self.bounds];
        [self addSubview:button];
         self.textLabel.text = self.textName;
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-30, 15, 10, 10)];
        lable.font = [UIFont systemFontOfSize:10];
        lable.textColor = [UIColor redColor];
        
        
//        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(self.bounds.size.width - 140, 10, 120, 20)];
        
//        MyUItextField *textField = [[MyUItextField alloc]initWithFrame:CGRectMake(self.bounds.size.width , 10, 120, 20)];
        MyUItextField *textField = [[MyUItextField alloc]initWithFrame:CGRectMake(0 , 0, self.bounds.size.width-60, self.bounds.size.height)];
        
        
        textField.textAlignment = UITextAlignmentRight;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        
        textField.tag = 1;
        textField.delegate =self;
//         UILabel *label = [UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width, , <#CGFloat width#>, <#CGFloat height#>)
        
        
   
        MyUItextField *textField2 = [[MyUItextField alloc]initWithFrame:CGRectMake(0 , 0, self.bounds.size.width-60, self.bounds.size.height)];
        

//        UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(self.bounds.size.width - 170, 10, 150, 20)];
        
        textField2.textAlignment = UITextAlignmentRight;
        textField2.keyboardType = UIKeyboardTypeNumberPad;
        textField.font = [UIFont systemFontOfSize:14];
        textField2.font = [UIFont systemFontOfSize:14];
        textField2.delegate = self;
        textField2.tag = 2;
        if ([self.textName isEqualToString:@"总金额"]||[self.textName isEqualToString:@"合同金额"]||[self.textName isEqualToString:@"金额"])
        {
           lable.text = @"万";
            
            textField.placeholder = @"请输入金额";
            [self addSubview:textField];
            
            [self addSubview:lable];
        }
        else if([self.textName isEqualToString:@"悬赏金额"])
        {
            lable.text = @"元";
        textField.placeholder = @"悬赏佣金";
            [button addSubview:textField];
           [self addSubview:lable];
        }
        else if ([self.textName isEqualToString:@"转让价"])
        {
            lable.text = @"万";
        textField2.placeholder = @"可输入具体价格";
            [button addSubview:textField2];
            [self addSubview:lable];
        }
        else if([self.textName isEqualToString:@"回报率"])
            
        {
            lable.text = @"%";
        textField2.placeholder = @"可接受的月化信息";
            [button addSubview:textField2];
            [self addSubview:lable];
        }

//        NSLog(@"--------------------------%@",self.textName);
//           if ([self.textName isEqualToString:@"总金额"]||[self.textName isEqualToString:@"合同金额"] || [self.textName isEqualToString:@"金额"]) {
////            textField.placeholder = @"请输入金额(万)";
////               [button addSubview:textField];
//               if ([self.forType isEqualToString:@"Type"]) {
//                   if ([self.typeName isEqualToString:@"悬赏信息"])
//                   {
//                       textField.placeholder = @"悬赏佣金(元)";
//                   }
//                   else
//                   {
//                       textField.placeholder = @"请输入金额(万)";
//                   }
//                   [button addSubview:textField];
//               }
//        }
//        
//        else if([self.textName isEqualToString:@"转让价"] )
//        {
//            textField2.placeholder = @"可输入具体价格(万)";
//            [button addSubview:textField2];
//        }
//        else if([self.textName isEqualToString:@"回报率"])
//        {
//            textField2.placeholder = @"可接受的月化信息%";
//            [button addSubview:textField2];
//        }
//    }
    }
  else
  {
      self.lable = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 200, 10, 140, 20)];
      self.lable.textAlignment = UITextAlignmentRight;
      
    self.lable.font = [UIFont systemFontOfSize:14];
      [self.contentView addSubview:self.lable];
    
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
    
}
- (void)setLable
{
    
    if ([self.LableText isEqualToString:@"1"]||[self.LableText isEqualToString:@"2"]||[self.LableText isEqualToString:@"3"]||[self.LableText isEqualToString:@"4"]||[self.LableText isEqualToString:@"5"])
    {
        self.lable.text = @"请选择";
        
    }
        
    self.lable.text = self.LableText;
    NSLog(@"!!!!!!!!!!!!!!!!%@",self.LableText);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (textField.tag == 1) {
        [defaults setObject:textField.text forKey:@"金额"];
        
    }
    else if(textField.tag == 2)
    {
        [defaults setObject:textField.text forKey:@"折扣"];
        
    }


}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (textField.tag == 1) {
        [defaults setObject:textField.text forKey:@"金额"];
        
    }
    else if(textField.tag == 2)
    {
        [defaults setObject:textField.text forKey:@"折扣"];
        
    }
  
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
