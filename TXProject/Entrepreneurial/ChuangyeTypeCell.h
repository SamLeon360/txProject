//
//  ChuangyeTypeCell.h
//  TXProject
//
//  Created by Sam on 2019/3/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChuangyeTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellIcon;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellContent;

@end

NS_ASSUME_NONNULL_END
