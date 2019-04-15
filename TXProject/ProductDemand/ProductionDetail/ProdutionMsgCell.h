//
//  ProdutionMsgCell.h
//  TXProject
//
//  Created by Sam on 2019/4/2.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProdutionMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *needNumber;

@property (weak, nonatomic) IBOutlet UILabel *productionType;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;

@end

NS_ASSUME_NONNULL_END
