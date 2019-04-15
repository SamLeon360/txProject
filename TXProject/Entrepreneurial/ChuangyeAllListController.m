//
//  ChuangyeAllListController.m
//  TXProject
//
//  Created by Sam on 2019/3/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ChuangyeAllListController.h"
#import "ChuangyeTypeCell.h"
#import "EntrepernurialAllListController.h"
@interface ChuangyeAllListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSArray *typeListArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *contentArray;
@property (nonatomic) NSArray *imageArray;
@end

@implementation ChuangyeAllListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部类别";
    self.typeListArray = @[@"工商注册",@"财税服务",@"知识产权",@"资质办理",@"法律服务",@"人力社保",@"场地服务",@"创业辅导",@"投融资",@"图文视频",@"视觉设计",@"市场传播",@"消防环保",@"物流快递",@"创业信息"];
    self.contentArray = @[@"公司注册/注册地址服务/公司变更",@"代理记账/税务代办/财务审计",@"商标注册/软件著作权/专利",@"经营许可证/其他行业许可证/高新企业",@"法律顾问/项目合规/股权期权",@"人才培训/商业保险/社保服务",@"场所租赁/创业基地/办公设施",@"创业培训/创业导师/创业顾问",@"投资机构/投资人",@"视频策划制作/图文策划制作",@"商标设计/平面广告设计",@"营销/推广/广告发布/新媒体",@"消防安监/环保环评",@"物流服务/快递服务",@"连锁加盟/项目转让/创业项目"];
    self.imageArray = @[@"entrepreneurship-information",@"entrepreneurship-tutoring",@"entrepreneurship-leasehold",@"entrepreneurship-officeFacilities",@"entrepreneurship-register",@"entrepreneurship-knowledge",@"entrepreneurship-financial",@"entrepreneurship-financing",@"entrepreneurship-adviser",@"entrepreneurship-open",@"entrepreneurship-Fire",@"entrepreneurship-protection",@"entrepreneurship-express",@"entrepreneurship-innovate",@"entrepreneurship-activities"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.typeListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChuangyeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChuangyeTypeCell"];
    [cell.cellIcon setImage:[UIImage imageNamed:self.imageArray[indexPath.row]] ];
    cell.cellTitle.text = self.typeListArray[indexPath.row];
    cell.cellContent.text = self.contentArray[indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self clickToEntre:self.typeListArray[indexPath.row]];
}
-(void)clickToEntre:(NSString *)type{
    EntrepernurialAllListController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"EntrepernurialAllListController"];
    vc.typeString = type;
    vc.serviceType = @"创业宝典";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
