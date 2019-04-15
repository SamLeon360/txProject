//
//  JobSelectView.h
//  TXProject
//
//  Created by Sam on 2019/3/28.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectStringCallBack)(NSString *str);
typedef void (^SelectCompanyCallBack)(NSDictionary *companyDic);
@interface JobSelectView : UIView
@property (nonatomic) SelectCompanyCallBack selectCompanyCallBack;
@property (nonatomic) SelectStringCallBack  selectStringCallBack;


@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *sureLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) BOOL muSelect;
-(void)setupTableView;

@end

NS_ASSUME_NONNULL_END
