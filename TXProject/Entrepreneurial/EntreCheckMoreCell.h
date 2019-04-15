//
//  EntreCheckMoreCell.h
//  TXProject
//
//  Created by Sam on 2019/4/11.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EntreCheckMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

NS_ASSUME_NONNULL_END
