//
//  StuJobOtherStuCell.h
//  TXProject
//
//  Created by Sam on 2019/3/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StuJobOtherStuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

NS_ASSUME_NONNULL_END
