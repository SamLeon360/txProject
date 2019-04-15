//
//  ProReplyCell.h
//  TXProject
//
//  Created by Sam on 2019/4/2.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProReplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *replyContent;
@property (weak, nonatomic) IBOutlet UILabel *replyBtn;

@end

NS_ASSUME_NONNULL_END
