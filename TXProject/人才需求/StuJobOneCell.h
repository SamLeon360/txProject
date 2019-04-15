//
//  StuJobOneCell.h
//  TXProject
//
//  Created by Sam on 2019/3/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StuJobOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *requirementLabel;
@property (weak, nonatomic) IBOutlet UILabel *welfareLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

NS_ASSUME_NONNULL_END
