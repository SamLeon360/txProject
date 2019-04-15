//
//  ProMsgCell.h
//  TXProject
//
//  Created by Sam on 2019/4/3.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UILabel *proTypeLB;
@property (weak, nonatomic) IBOutlet UITextField *needNumber;
@property (weak, nonatomic) IBOutlet UITextField *unit;
@property (weak, nonatomic) IBOutlet UIView *typeView;

@end

NS_ASSUME_NONNULL_END
