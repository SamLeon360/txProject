//
//  ProCompanyListCell.h
//  TXProject
//
//  Created by Sam on 2019/4/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProCompanyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;

@end

NS_ASSUME_NONNULL_END
