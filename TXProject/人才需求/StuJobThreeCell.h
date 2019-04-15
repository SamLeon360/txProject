//
//  StuJobThreeCell.h
//  TXProject
//
//  Created by Sam on 2019/3/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StuJobThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIView *phoneView;

@end

NS_ASSUME_NONNULL_END
