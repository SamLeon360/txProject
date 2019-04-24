//
//  ComDetailSectionCell.h
//  TXProject
//
//  Created by Sam on 2019/4/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComDetailSectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectionTitle;
@property (weak, nonatomic) IBOutlet UIImageView *cellIcon;
@property (nonatomic,assign) NSInteger tableType;//1--基本信息,3--监.理事会
@property (nonatomic,strong) NSArray *masterList;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
