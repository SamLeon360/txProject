//
//  MineViewHeader.h
//  TXProject
//
//  Created by Sam on 2019/1/3.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineViewHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userType;
@property (weak, nonatomic) IBOutlet UILabel *messageNumber;
@property (weak, nonatomic) IBOutlet UILabel *dongtaiNumber;
@property (weak, nonatomic) IBOutlet UILabel *friendsNumber;
@property (weak, nonatomic) IBOutlet UIView *accountMessageView;
@property (weak, nonatomic) IBOutlet UIView *typeMessageView;
@property (weak, nonatomic) IBOutlet UIView *useFunctionVieew;
@property (weak, nonatomic) IBOutlet UIView *appSettingView;

@end

NS_ASSUME_NONNULL_END
