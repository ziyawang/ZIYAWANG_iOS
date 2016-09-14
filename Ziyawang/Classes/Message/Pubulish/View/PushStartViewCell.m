//
//  PushStartViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/1.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PushStartViewCell.h"
#import "MyUItextField.h"
#import "AppDelegate.h"
@interface PushStartViewCell()<UITextFieldDelegate>
@property (nonatomic,strong) NSString *forType;
@property (nonatomic,assign)   BOOL isHaveDian;

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
    
    self.isHaveDian = NO;
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
    if([self.textName isEqualToString:@"总金额"] || [self.textName isEqualToString:@"转让价"] || [self.textName isEqualToString:@"金额"] || [self.textName isEqualToString:@"合同金额"] || [self.textName isEqualToString:@"回报率"]||[self.textName isEqualToString:@"悬赏金额"]||[self.textName isEqualToString:@"预期回报率"])
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
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        
        
        textField.tag = 1;
        textField.delegate =self;
//         UILabel *label = [UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width, , <#CGFloat width#>, <#CGFloat height#>)
        
        
   
        MyUItextField *textField2 = [[MyUItextField alloc]initWithFrame:CGRectMake(0 , 0, self.bounds.size.width-60, self.bounds.size.height)];
        

//        UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(self.bounds.size.width - 170, 10, 150, 20)];
        
        textField2.textAlignment = UITextAlignmentRight;
        textField2.keyboardType = UIKeyboardTypeDecimalPad;
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
        else if([self.textName isEqualToString:@"预期回报率"])
        {
        lable.text = @"%";
            textField2.placeholder = @"请输入回报率";
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
#pragma mark - UITextField delegate
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger value = [textField.text integerValue];
        if (value > 999999.9) {
            textField.text = [textField.text substringToIndex:6];
//            [self showError:@"您输入的位数过多"];
        }

    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        self.isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [self showError:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    [self showError:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(self.isHaveDian==NO)//text中还没有小数点
                {
                    self.isHaveDian = YES;
                    return YES;
                    
                }else{
                    [self showError:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
//                        [self showError:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self showError:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)showError:(NSString *)errorString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
//    [(AppDelegate *)[UIApplication sharedApplication].delegate showErrorView:errorString];
//    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeErrorView2) userInfo:nil repeats:NO];
    
//    [self.moneyTf resignFirstResponder];
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
