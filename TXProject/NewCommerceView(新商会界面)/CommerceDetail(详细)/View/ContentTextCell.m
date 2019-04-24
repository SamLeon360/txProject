//
//  ContentTextCell.m
//  TXProject
//
//  Created by Sam on 2019/4/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ContentTextCell.h"

@implementation ContentTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CommerceBaseModel *)model{
    if (model == nil) {
        return;
    }
    NSArray *oneValueArray = @[model.commerce_president,model.executive_president,model.supervisor,model.commerce_secretary_general];
    NSArray *oneKeyArray = @[@"会长：",@"执行会长：",@"监事长：",@"秘书长："];
    NSArray *twoValueArray = @[model.commerce_phone,model.commerce_fax,model.contact,model.contact_phone,model.email,model.office_address];
    NSArray *twoKeyArray = @[@"社团电话：",@"传真：",@"联系人：",@"联系人手机：",@"E-mail：",@"办公地址："];
    if (self.indexPath.section == 2) {
        _cellTitle.text = oneKeyArray[self.indexPath.row-1];
        _contentLabel.text = oneValueArray[self.indexPath.row-1];
    }else if (self.indexPath.section == 5){
        _cellTitle.text = twoKeyArray[self.indexPath.row-1];
        _contentLabel.text = twoValueArray[self.indexPath.row-1];
        if ([_cellTitle.text isEqualToString:@"联系人手机："]) {
            [_cellIcon setImage:[UIImage imageNamed:@"IOS_Phone_Blue"]];
            _cellIcon.hidden = NO;
        }else{
            _cellIcon.hidden = YES;
        }
    }
}

-(void)setMasterModel:(CommerceMasterModel *)masterModel{
    if (masterModel == nil) {
        return;
    }
    _cellTitle.text = masterModel.league_post;
    _contentLabel.text = masterModel.member_name;
}
@end
