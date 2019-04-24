//
//  ComDetailSectionCell.m
//  TXProject
//
//  Created by Sam on 2019/4/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ComDetailSectionCell.h"

@implementation ComDetailSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    if (self.tableType == 1) {
        self.cellIcon.hidden = NO;
        NSArray *arr = @[@"社团简介",@"社团主要负责人",@"秘书处介绍",@"入会条件",@"联系信息"];
        self.sectionTitle.text = arr[indexPath.section-1];
    }else{
        self.cellIcon.hidden =  YES;
        self.sectionTitle.text = [NSString stringWithFormat:@"第%ld届监、理事会",indexPath.section];
    }
}

@end
