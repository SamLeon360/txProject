//
//  ProCompanyCell.h
//  TXProject
//
//  Created by Sam on 2019/4/2.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProCompanyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *companyIcon;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyAddress;
@property (weak, nonatomic) IBOutlet UILabel *companyType;

@end

NS_ASSUME_NONNULL_END
