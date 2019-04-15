//
//  CommentCell.h
//  TXProject
//
//  Created by Sam on 2019/3/26.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@end

NS_ASSUME_NONNULL_END
