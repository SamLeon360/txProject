//
//  ProductionListCell.h
//  TXProject
//
//  Created by Sam on 2019/3/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIImageView *proImage;
@property (weak, nonatomic) IBOutlet UILabel *area;

@end

NS_ASSUME_NONNULL_END
