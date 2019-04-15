//
//  ProductionContactCell.h
//  TXProject
//
//  Created by Sam on 2019/4/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductionContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
@property (weak, nonatomic) IBOutlet UITextField *area;

@end

NS_ASSUME_NONNULL_END
