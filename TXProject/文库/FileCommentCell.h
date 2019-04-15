//
//  FileCommentCell.h
//  TXProject
//
//  Created by Sam on 2019/3/27.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

NS_ASSUME_NONNULL_END
