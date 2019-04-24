//
//  EntrepernurialAllListController.m
//  TXProject
//
//  Created by Sam on 2019/1/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EntrepernurialAllListController.h"
#import "EntreListCell.h"
#import "TXWebViewController.h"
#import "MJRefresh.h"
#import "EntreDetailController.h"
#import "AddServiceFormController.h"
@interface EntrepernurialAllListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic) UIButton *addDataBtn;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSArray *typeArray;
@property (nonatomic) NSDictionary *titleDic;
@property (nonatomic) NSInteger nPage;
@end

@implementation EntrepernurialAllListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.nPage = 1;
    self.titleDic = [self.serviceType isEqualToString:@"综合服务"]?@{@"融资信贷":@"1",@"科技创新":@"2",@"健康体检":@"3",@"活动策划":@"4",@"高端定制":@"5",@"车辆保养":@"6",@"展会展览":@"7",@"住宿餐饮":@"8",@"涉外服务":@"9",@"项目申报":@"10",@"房地产":@"11",@"商务翻译":@"12",@"公司搬迁":@"13",@"摄影摄像":@"14",@"汽车租赁":@"15"}: @{@"工商注册":@"1",@"财税服务":@"5",@"知识产权":@"8",@"资质办理":@"10",@"法律服务":@"18",@"人力社保":@"21",@"场地服务":@"25",@"创业辅导":@"27",@"投融资":@"29",@"图文视频":@"33",@"视觉设计":@"36",@"市场传播":@"37",@"消防环保":@"38",@"物流快递":@"39",@"创业信息":@"41"};
    self.typeArray = [self.serviceType isEqualToString:@"综合服务"]?@[@"融资信贷",@"科技创新",@"健康体检",@"活动策划",@"高端定制",@"车辆保养",@"展会展览",@"住宿餐饮",@"涉外服务",@"房地产",@"商务翻译",@"公司搬迁",@"摄影摄像",@"汽车租赁"]:@[@"工商注册",@"财税服务",@"知识产权",@"资质办理",@"法律服务",@"人力社保",@"场地服务",@"创业辅导",@"投融资",@"图文视频",@"视觉设计",@"市场传播",@"消防环保",@"物流快递",@"创业信息"];
    [self getDataArrayByRefresh];
    self.title = self.typeString;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataArrayByMore)];
    self.tableView.mj_footer = footer;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self getDataArrayByRefresh];
    }];
    __block EntrepernurialAllListController *blockSelf = self;
    [self.searchBtn bk_whenTapped:^{
        [blockSelf getDataArrayByRefresh];
        [blockSelf.view endEditing:YES];
    }];
    [self.view addSubview:self.addDataBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataArrayByRefresh) name:@"getDataArrayByRefresh" object:nil];
}

-(void)getDataArrayByRefresh{
    self.nPage = 1;
    __block EntrepernurialAllListController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",self.titleDic[self.typeString],@"service_type",@"",@"affiliated_area",@"2333",@"list_one",self.searchTF.text,@"member_name",@"2",@"_search_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:[self.serviceType isEqualToString:@"综合服务"]?SH_ZONGHE_ALL:  SH_BAODIAN_ALL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            blockSelf.dataArray = [NSMutableArray arrayWithCapacity:0];
            [blockSelf.dataArray addObjectsFromArray:responseDic[@"data"]];
            
        }
        [blockSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


-(void)getDataArrayByMore{
    self.nPage ++;
      __block EntrepernurialAllListController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.nPage],@"page",self.titleDic[self.typeString],@"service_type",@"",@"affiliated_area",@"2333",@"list_one",self.searchTF.text,@"member_name",@"2",@"_search_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:[self.serviceType isEqualToString:@"综合服务"]?SH_ZONGHE_ALL:  SH_BAODIAN_ALL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSArray *arr = responseDic[@"data"];
        if ([responseDic[@"code"] integerValue] == 1) {
            if (arr.count > 0) {
                [blockSelf.dataArray addObjectsFromArray:responseDic[@"data"]];
                 [blockSelf.tableView.mj_footer endRefreshing];
            }else{
                blockSelf.nPage  -- ;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
        
        }else{
            blockSelf.nPage -- ;
             [blockSelf.tableView.mj_footer endRefreshing];
        }
        [blockSelf.tableView reloadData];
       
    } failure:^(NSError *error) {
         blockSelf.nPage  -- ;
        [blockSelf.tableView.mj_footer endRefreshing];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EntreListCell *cell = (EntreListCell *)[tableView cellForRowAtIndexPath:indexPath];
    EntreDetailController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"EntreDetailController"];
    vc.title = self.title;
    vc.typeString = self.serviceType;
    vc.serviceType = cell.oneTag.text;
    vc.dataDic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreListCell"];
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (![dic[@"service_img"] isKindOfClass:[NSNull class]]) {
        NSArray *imageurlArr = [dic[@"service_img"] componentsSeparatedByString:@"|"];
        [cell.cellView makeCorner:5];
        [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?imageslim",AVATAR_HOST_URL,imageurlArr[0]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [cell.cellImage setImage:[UIImage imageNamed:@"default_avatar"]];
            }
        }];
    }
    if ([self.serviceType isEqualToString:@"综合服务"]) {
        [self.titleDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([ obj integerValue] == [dic[@"service_type"] integerValue]) {
                cell.oneTag.text = key;
            }
        }];
        
    }else{
        [self.titleDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([ obj integerValue] == [dic[@"service_type"] integerValue]) {
                cell.oneTag.text = key;
            }
        }];
    }
    cell.twoTag.text = dic[@"member_name"];
    cell.titleCell.text = dic[@"service_title"];
    cell.priceCell.text = [NSString stringWithFormat:@"%@",dic[@"fee_mode"]];
    if (![dic[@"area"] isKindOfClass:[NSNull class]]) {
       cell.addressCell.text = [dic[@"area"] stringByReplacingOccurrencesOfString:@"|" withString:@""];
    }
    
    return cell;
}
-(UIButton *)addDataBtn{
    if (!_addDataBtn) {
        _addDataBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW-192)/2, ScreenH-170, 192, 62 )];
        _addDataBtn.hidden = NO;
        [_addDataBtn setImage:[UIImage imageNamed:@"cy_zh_bottom_btn"] forState:UIControlStateNormal];
        __block EntrepernurialAllListController *blockSelf = self;
        [_addDataBtn bk_whenTapped:^{
            if (USER_SINGLE.token.length <= 0) {
                [AlertView showYMAlertView:self.view andtitle:@"请先登录!"];
                return ;
            }
            AddServiceFormController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"AddServiceFormController"];
            vc.typeString = self.serviceType ;
            vc.typeIndex = [blockSelf.titleDic[blockSelf.title] integerValue];
            [self.navigationController pushViewController:vc animated:YES];
//            TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
//            vc.webUrl =  [NSString stringWithFormat:@"%@%@",WEB_HOST_URL,[NSString stringWithFormat:[blockSelf.serviceType isEqualToString:@"综合服务"]?@"table_join_multiServer///%@/1":@"venture_addition///%@/",blockSelf.titleDic[blockSelf.typeString]]];
//
//            [blockSelf.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    return _addDataBtn;
}
@end
