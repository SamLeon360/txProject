//
//  EightBlockCell.h
//  TXProject
//
//  Created by Sam on 2019/2/12.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EightBlockCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *commerceView;
@property (weak, nonatomic) IBOutlet UIView *chuangyeView;
@property (weak, nonatomic) IBOutlet UIView *zongheView;
@property (weak, nonatomic) IBOutlet UIView *xinzhengView;
@property (weak, nonatomic) IBOutlet UIView *zhaoshangView;
@property (weak, nonatomic) IBOutlet UIView *peopleNeedView;
@property (weak, nonatomic) IBOutlet UIView *libraryView;

@end

NS_ASSUME_NONNULL_END
