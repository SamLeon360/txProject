//
//  UpdateAlertView.h
//  YKMX
//
//  Created by apple on 2017/9/28.
//  Copyright © 2017年 chenshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *NewVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLogLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowAvailbeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentVersionLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;


@property(nonatomic)NSDictionary *dataDic;
-(void)initwithData;
@end
