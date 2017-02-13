//
//  CollectNewsCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CollectNewsCell.h"

@interface CollectNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *NewsLogo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *BriefLabel;


@end

@implementation CollectNewsCell


- (void)setModel:(CollectModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setCell];
    }
}
- (void)setCell
{
    if (self.model.NewsLogo != nil) {
        NSString *URL = [getImageURL stringByAppendingString:self.model.NewsLogo];
        [self.NewsLogo sd_setImageWithURL:[NSURL URLWithString:URL]];
        
    }
    self.titleLabel.text = self.model.NewsTitle;
    NSString *htmlString = self.model.Brief;
    NSAttributedString * attrStr =  [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    NSString *str = [NSString stringWithFormat:@"%@",attrStr];
    self.BriefLabel.attributedText = attrStr;
    

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
