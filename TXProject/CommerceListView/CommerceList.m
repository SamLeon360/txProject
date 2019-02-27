//
//  CommerceList.m
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "CommerceList.h"
#import "AppDelegate.h"
#import "TXMainViewController.h"
#import "CommerceCell.h"
@interface CommerceList()<UITableViewDelegate,UITableViewDataSource>
@end
@implementation CommerceList
//
//-(NSArray *)commerceArray{
////        [self.tableView registerNib:[UINib  nibWithNibName:@"CommerceCell" bundle:nil] forCellReuseIdentifier:@"CommerceCell"];
////        self.tableView.delegate = self;
////        self.tableView.dataSource = self;
//    
//        _commerceArray = self.commerceArray;
////        [self.tableView reloadData];
//    
//    return _commerceArray;
//}
-(void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib  nibWithNibName:@"CommerceCell" bundle:nil] forCellReuseIdentifier:@"CommerceCell"];
     [self.tableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commerceArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic  = self.commerceArray[indexPath.row];
    USER_SINGLE.default_role_type = dic[@"role_id"];
    USER_SINGLE.default_commerce_id = dic[@"commerce_id"];
    USER_SINGLE.default_commerce_name = dic[@"commerce_name"];
    USER_SINGLE.commerceDic = dic;
    [self.mineVC updateDefaultCommerce];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//        TXMainViewController *mainVC = [[TXMainViewController alloc] init];
//        mainVC.tabBar.hidden = NO;
//        [mainVC setSelectedIndex:0];
//        appDelegate.window.rootViewController = mainVC;
//    });
   
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommerceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommerceCell"];
    NSDictionary *dic = self.commerceArray[indexPath.row];
    cell.commerceName.text = dic[@"commerce_name"];
    cell.userType.text = [dic[@"role_id"] integerValue] == 1?@"秘书处":@"会员";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


@end
