//
//  LibraryListCell.h
//  TXProject
//
//  Created by Sam on 2019/3/26.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LibraryListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *outView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *downloadCount;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkDetailLabel;

@end

NS_ASSUME_NONNULL_END
