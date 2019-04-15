//
//  ProductionUploadNormalCell.h
//  TXProject
//
//  Created by Sam on 2019/3/28.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JobUploadNormalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@end

NS_ASSUME_NONNULL_END
