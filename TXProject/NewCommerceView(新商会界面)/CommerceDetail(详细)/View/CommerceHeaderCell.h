//
//  CommerceHeaderCell.h
//  TXProject
//
//  Created by Sam on 2019/4/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommerceBaseModel.h"
#import "NewCommerceDetailController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommerceHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commerceLogo;
@property (weak, nonatomic) IBOutlet UILabel *commerceName;
@property (weak, nonatomic) IBOutlet UIView *baseMsgView;
@property (weak, nonatomic) IBOutlet UILabel *baseMsgLabel;
@property (weak, nonatomic) IBOutlet UIView *eventView;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UILabel *masterLabel;
@property (nonatomic,strong)CommerceBaseModel *model;
@property (nonatomic) NewCommerceDetailController *commerceDetailVC;
@end

NS_ASSUME_NONNULL_END
