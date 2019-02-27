//
//  PayServiceView.h
//  TXProject
//
//  Created by Sam on 2019/2/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayServiceView : UIView
@property (weak, nonatomic) IBOutlet UIView *closeView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UIView *wxView;
@property (weak, nonatomic) IBOutlet UIImageView *aliPayStatusImage;
@property (weak, nonatomic) IBOutlet UIImageView *wxStatusIamge;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

NS_ASSUME_NONNULL_END
