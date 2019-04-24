//
//  JobListController.m
//  TXProject
//
//  Created by Sam on 2019/3/29.
//  Copyright © 2019 sam. All rights reserved.
//
#import "JobPostAndEditController.h"
#import "JobListController.h"
#import "JobListCell.h"
#import "MJRefresh.h"
#import "StudentJobDetailController.h"
@interface JobListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *jobArray;
@property (nonatomic) NSInteger nPage;
@end

@implementation JobListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.s
    self.title = @"人才需求信息";
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
   
    [self GetCompanyData];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetJobListMore)];
    self.tableView.mj_footer = footer;
    self.tableView.tableFooterView = [[UIView alloc] init];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onClickToUpload)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
-(void)viewWillAppear:(BOOL)animated{
     [self GetJobList];
}
-(void)GetCompanyData{
    __block JobListController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_COMPANY_LIST parameters:@{@"member_id":USER_SINGLE.member_id} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue]== 0) {
            blockSelf.companyArray = responseDic[@"data"];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)onClickToUpload{
    if (USER_SINGLE.token.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请先登录"];
        return;
    }
    if (self.companyArray.count <= 0 || self.companyArray  == nil) {
        [AlertView showYMAlertView:self.view andtitle:@"请先创建公司"];
        return;
    }
    
    JobPostAndEditController *vc = [[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"JobPostAndEditController"];
    vc.companyArray = self.companyArray;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)GetJobList{
    self.nPage = 1;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",@"1",@"allow_publish",USER_SINGLE.default_commerce_id,@"commerce_id",@"",@"education",@"",@"enterprise_id",@"",@"ios",@"",@"job_name",@"",@"job_type",[NSString stringWithFormat:@"%ld",self.nPage],@"page",@"",@"receive_fresh_graduate",@"",@"work_type",@"1",@"_search_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_OTHER_JOB parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            self.jobArray = [NSMutableArray arrayWithArray:responseDic[@"data"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)GetJobListMore{
     self.nPage ++;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",@"",@"allow_publish",USER_SINGLE.default_commerce_id,@"commerce_id",@"",@"education",@"",@"enterprise_id",@"",@"ios",@"",@"job_name",@"",@"job_type",[NSString stringWithFormat:@"%ld",self.nPage],@"page",@"",@"receive_fresh_graduate",@"",@"work_type",@"1",@"_search_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_OTHER_JOB parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
          
            NSArray *arr = responseDic[@"data"];
            [self.jobArray addObjectsFromArray:arr];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            self.nPage --;
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.nPage --;
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jobArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobListCell"];
    NSDictionary *dic = self.jobArray[indexPath.row];
    cell.title.text = dic[@"job_name"];
    __block JobListController *blockSelf = self;
    [cell.delLabel bk_whenTapped:^{
        NSIndexPath *indexP = [blockSelf.tableView indexPathForCell:cell];
        [blockSelf deleteCellData:indexP];
    }];
    [cell.updateLabel bk_whenTapped:^{
        NSIndexPath *indexP = [blockSelf.tableView indexPathForCell:cell];
        JobPostAndEditController *vc =[[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"JobPostAndEditController"];
        vc.companyArray = blockSelf.companyArray;
        vc.editData = blockSelf.jobArray[indexP.row];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell.detailLabel bk_whenTapped:^{
        NSIndexPath *indexP = [blockSelf.tableView indexPathForCell:cell];
        StudentJobDetailController *vc = [[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"StudentJobDetailController"];
        vc.selectData = blockSelf.jobArray[indexP.row];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
-(void)deleteCellData:(NSIndexPath * )indexPath{
    NSDictionary *dic = self.jobArray[indexPath.row];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"3",@"allow_publish",USER_SINGLE.default_commerce_id,@"commerce_id",@"0",@"handle_type",[NSString stringWithFormat:@"%@",dic[@"talent_id"]],@"talent_id", nil];
     [HTTPREQUEST_SINGLE postWithURLString:SH_HANDLE_TALENT parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == -1002) {
            [self GetJobList];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
