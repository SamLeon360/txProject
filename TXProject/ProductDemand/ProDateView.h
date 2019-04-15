//
//  ProDateView.h
//  TXProject
//
//  Created by Sam on 2019/3/28.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectStringCallBack)(NSString *str);
@interface ProDateView : UIView
@property (nonatomic) SelectStringCallBack  selectStringCallBack;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UILabel *sureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *closeView;
-(void)setupDatePicker;
@end

NS_ASSUME_NONNULL_END
