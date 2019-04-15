//
//  PersonThreeMsgCell.h
//  TXProject
//
//  Created by Sam on 2019/3/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonThreeMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *oneTitle;
@property (weak, nonatomic) IBOutlet UILabel *twoTitle;
@property (weak, nonatomic) IBOutlet UILabel *threeTitle;
@property (weak, nonatomic) IBOutlet UILabel *oneContent;
@property (weak, nonatomic) IBOutlet UILabel *twoContent;
@property (weak, nonatomic) IBOutlet UILabel *threeContent;

@end

NS_ASSUME_NONNULL_END
