//
//  ComprehensiveServerController.m
//  TXProject
//
//  Created by Sam on 2019/1/17.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ComprehensiveServerController.h"
#import "ServerHeader.h"
#import "MJRefresh.h"
#import "HottopicCell.h"
#import "TXWebViewController.h"
#import "EntrepernurialAllListController.h"
@interface ComprehensiveServerController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSInteger nPage;
@property (nonatomic) NSMutableArray *hottopicArray;
@property (nonatomic) NSMutableArray *advertImageArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ServerHeader *entreHeader;


@end

@implementation ComprehensiveServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"综合服务";
    [self.tableView registerNib:[UINib nibWithNibName:@"HottopicCell" bundle:nil] forCellReuseIdentifier:@"HottopicCell"];
    self.nPage = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.advertImageArray = [NSMutableArray arrayWithCapacity:0];
    self.hottopicArray = [NSMutableArray arrayWithCapacity:0];
    [self getAdvertImage];
    [self getDataListRefresh];
    
    __block ComprehensiveServerController *blockSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行数据刷新操作
        [blockSelf getDataListRefresh];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataListMore)];
    self.tableView.mj_footer = footer;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)getDataListMore{
    __block ComprehensiveServerController *blockSelf = self;
    self.nPage ++;
    NSDictionary *param =  [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"2",@"type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_SERVER_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            
            [blockSelf.hottopicArray addObjectsFromArray:responseDic[@"data"] ];
            [blockSelf.tableView reloadData];
            
        }else{
            blockSelf.nPage --;
        }
        [blockSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        blockSelf.nPage -- ;
        [blockSelf.tableView.mj_footer endRefreshing];
    }];
}
-(void)getDataListRefresh{
    __block ComprehensiveServerController *blockSelf = self;
    NSDictionary *param =  [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"2",@"type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_SERVER_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            blockSelf.nPage = 1;
            blockSelf.hottopicArray = [NSMutableArray arrayWithCapacity:0];
            [blockSelf.hottopicArray addObjectsFromArray:responseDic[@"data"] ];
            [blockSelf.tableView reloadData];
            
        }
        [blockSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [blockSelf.tableView.mj_header endRefreshing];
    }];
}
-(void)getAdvertImage{
    __block ComprehensiveServerController *blockSelf = self;
    [HTTPREQUEST_SINGLE getWithURLString:GROUND_SCROLL_IMAGE parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSString *imgURLString = responseDic[@"data"][@"service_img"];
            NSArray *imageurlArray = [imgURLString componentsSeparatedByString:@"|"];
            blockSelf.advertImageArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i <= imageurlArray.count - 1; i ++) {
                NSString *imageString = [NSString stringWithFormat:@"%@%@",@"https://app.tianxun168.com",imageurlArray[i]];
                [blockSelf.advertImageArray addObject:imageString];
            }
            self.tableView.tableHeaderView = self.entreHeader;
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hottopicArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellDic = self.hottopicArray[indexPath.row];
    HottopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HottopicCell"];
    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?imageView2/1/w/200/h/200",AVATAR_HOST_URL,cellDic[@"headlines_img"]]]];
    [cell.cellContent setText:cellDic[@"headlines"]];
    NSString *timeString = [cellDic[@"publish_time"] componentsSeparatedByString:@" "][0];
    [cell.cellTime setText:timeString];
    cell.cellImage.layer.masksToBounds = YES;
    [cell.cellView makeCorner:5];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.hottopicArray[indexPath.row];
//    NSString *urlString = [NSString stringWithFormat:@"%@integrated_service/integrated_list_details/%@/1",WEB_HOST_URL,dic[@"id"]];
   TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    vc.dataDic = dic;
    vc.title = @"行业热门话题详情";
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)clickToWebView:(NSString *)urlString andTitle:(NSString *)title{
    TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    vc.webUrl = urlString;
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}
-(ServerHeader *)entreHeader{
    
    _entreHeader = [[NSBundle mainBundle] loadNibNamed:@"Entrepreneurial" owner:self options:nil][1];
    _entreHeader.cycleScrollview.imageURLStringsGroup = self.advertImageArray;
    _entreHeader.cycleScrollview.showPageControl = YES;
    [_entreHeader.cycleScrollview makeCorner:10];
    _entreHeader.frame = CGRectMake(0, 0, ScreenW, 439*kScale);
    __block ComprehensiveServerController *blockSelf = self;
    [_entreHeader.treasureView bk_whenTapped:^{
 
        [blockSelf clickToEntre:@"银行信贷"];
    }];
    [_entreHeader.coachView bk_whenTapped:^{
    
     [blockSelf clickToEntre:@"健康保健"];
    }];
    [_entreHeader.leaseView bk_whenTapped:^{
        [blockSelf clickToEntre:@"活动策划"];
        
    }];
    [_entreHeader.facilitiesView bk_whenTapped:^{
        [blockSelf clickToEntre:@"境外游学"];
    }];
    [_entreHeader.circlesView bk_whenTapped:^{
        [blockSelf clickToEntre:@"保险代理"];
    }];
    [_entreHeader.knowledgeView bk_whenTapped:^{
        [blockSelf clickToEntre:@"高端定制"];
    }];
    [_entreHeader.lawView bk_whenTapped:^{
        [blockSelf clickToEntre:@"商务翻译"];
    }];
    [_entreHeader.financingView bk_whenTapped:^{
       [blockSelf clickToEntre:@"公司搬迁"];
    }];
    [_entreHeader.adviserView bk_whenTapped:^{
       [blockSelf clickToEntre:@"健康保健"];
    }];
    [_entreHeader.moreView bk_whenTapped:^{
        [blockSelf clickToEntre:@"车辆维护保养"];
    }];
    [_entreHeader.busnessOutView bk_whenTapped:^{
       [blockSelf clickToEntre:@"商务出行"];
    }];
    [_entreHeader.tickectServerView bk_whenTapped:^{
        [blockSelf clickToEntre:@"票卷服务"];
    }];
    [_entreHeader.clickCheckMoreView bk_whenTapped:^{
        [blockSelf clickToWebView:[NSString stringWithFormat:@"%@services_public/1/2/1",WEB_HOST_URL] andTitle:@"行业热门话题"];
    }];
    return _entreHeader;
}
-(void)clickToEntre:(NSString *)type{
    EntrepernurialAllListController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"EntrepernurialAllListController"];
    vc.typeString = type;
    vc.serviceType = @"综合服务";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
