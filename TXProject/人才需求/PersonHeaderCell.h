//
//  PersonHeaderCell.h
//  TXProject
//
//  Created by Sam on 2019/3/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *school;
@property (weak, nonatomic) IBOutlet UILabel *major;

@end

NS_ASSUME_NONNULL_END
