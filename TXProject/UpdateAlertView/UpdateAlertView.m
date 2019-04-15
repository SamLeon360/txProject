//
//  UpdateAlertView.m
//  YKMX
//
//  Created by apple on 2017/9/28.
//  Copyright © 2017年 chenshuo. All rights reserved.
//

#import "UpdateAlertView.h"
#import "AppDelegate.h"
@implementation UpdateAlertView

-(void)initwithData{
    //1.0.1--101
    //2.0.0
    NSString *currentVersion = [[NSString stringWithFormat:@"%@",self.dataDic[@"currentVersion"]] stringByReplacingOccurrencesOfString:@"." withString:@""];
    //1.0.2--102
    //2.0.1
    NSString *requireVersion =[[NSString stringWithFormat:@"%@",self.dataDic[@"required_version"]] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
//    if ([currentVersion intValue] < [requireVersion intValue]) {
        [self.cancelBtn bk_addEventHandler:^(id sender) {
            exit(0);
        } forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        [self.cancelBtn setTitle:@"以后再说" forState:UIControlStateNormal];
//        [self.cancelBtn bk_addEventHandler:^(id sender) {
//            [self removeFromSuperview];
//        } forControlEvents:UIControlEventTouchUpInside];
//    }
    [self.updateBtn bk_addEventHandler:^(id sender) {
      
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.dataDic[@"trackViewUrl"]] options:nil completionHandler:^(BOOL success) {
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    self.NewVersionLabel.text = [NSString stringWithFormat:@"检测到新版本%@",self.dataDic[@"version"]];
    self.versionLogLabel.text = self.dataDic[@"changeStr"];
    self.lowAvailbeLabel.text = @"";
//    [NSString stringWithFormat:@"最低可用版本:%@",self.dataDic[@"required_version"]];
    self.currentVersionLabel.text = @"";
//    [NSString stringWithFormat:@"当前版本:%@",self.dataDic[@"currentVersion"]];
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
}



@end
