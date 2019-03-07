//
//  ProjectSelectView.h
//  TXProject
//
//  Created by Sam on 2019/3/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectSelectView : UIView
@property (weak, nonatomic) IBOutlet UITextField *maxPriceTF;
@property (weak, nonatomic) IBOutlet UITextField *minPriceTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

NS_ASSUME_NONNULL_END
