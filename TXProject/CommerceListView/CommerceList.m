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
@property (nonatomic) NSArray *commerceJobArray;
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
    self.commerceJobArray = @[ @"会长",@"执行会长",@"常务副会长",@"副会长",@"常务理事",@"理事",@"监事长",@"副监事长",@"监事",@"名誉会长",@"荣誉会长",@"创会会长",@"顾问",@"秘书长",@"执行秘书长",@"专职秘书长",@"副秘书长",@"干事",@"办公室主任",@"文员",@"部长",@"会员",@"创会会长"];
    
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
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [newDic setObject:@"" forKey:key];
        }else{
            [newDic setObject:obj forKey: key];
        }
    }];
    USER_SINGLE.commerceDic = newDic;
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
    cell.userType.text = self.commerceJobArray[[dic[@"member_post_in_commerce"] integerValue] - 1];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


@end
