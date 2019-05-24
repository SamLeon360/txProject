//
//  ProDateView.m
//  TXProject
//
//  Created by Sam on 2019/3/28.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProDateView.h"
@interface ProDateView()
@property (nonatomic) NSString *timeString;
@end
@implementation ProDateView
-(void)setupDatePicker{
    [self.datePickerView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.sureBtn bk_whenTapped:^{
        self.hidden = NO;
        if (self.timeString == nil) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *datenow = [NSDate date];
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            self.timeString = currentTimeString;
        }
       self.selectStringCallBack(self.timeString);
    }];
    [self.closeView bk_whenTapped:^{
        self.hidden = NO;
    }];
}
-(void)dateChange:(UIDatePicker *)pickerView{
    NSDate *theDate = pickerView.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    self.timeString = [dateFormatter stringFromDate:theDate];
}


@end
