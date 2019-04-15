//
//  MineProductCell.h
//  TXProject
//
//  Created by Sam on 2019/4/6.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *proImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *needNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *areaLB;
@property (weak, nonatomic) IBOutlet UIView *putdownView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@end

NS_ASSUME_NONNULL_END
