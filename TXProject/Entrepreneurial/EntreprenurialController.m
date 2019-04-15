//
//  EntreprenurialController.m
//  TXProject
//
//  Created by Sam on 2019/1/11.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EntreprenurialController.h"
#import "HottopicCell.h"
#import "Entrepreneurial.h"
#import "MJRefresh.h"
#import "TXWebViewController.h"
#import "ChuangyeAllListController.h"
#import "EntrepernurialAllListController.h"
#import "EntreCheckMoreController.h"
@interface EntreprenurialController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSInteger nPage;
@property (nonatomic) NSMutableArray *hottopicArray;
@property (nonatomic) NSMutableArray *advertImageArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Entrepreneurial *entreHeader;
@end

@implementation EntreprenurialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创业宝典";
    [self.tableView registerNib:[UINib nibWithNibName:@"HottopicCell" bundle:nil] forCellReuseIdentifier:@"HottopicCell"];
    self.nPage = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.advertImageArray = [NSMutableArray arrayWithCapacity:0];
    self.hottopicArray = [NSMutableArray arrayWithCapacity:0];
    [self getAdvertImage];
    [self getDataListRefresh];
    
    __block EntreprenurialController *blockSelf = self;
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
    __block EntreprenurialController *blockSelf = self;
    blockSelf.nPage ++;
    NSDictionary *param =  [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"1",@"type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:ENTRE_LIST_DATA parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            
            [blockSelf.hottopicArray addObjectsFromArray:responseDic[@"data"] ];
            [blockSelf.tableView reloadData];
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [blockSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            blockSelf.nPage --;
            [blockSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        blockSelf.nPage -- ;
        [blockSelf.tableView.mj_footer endRefreshing];
    }];
}
-(void)getDataListRefresh{
    __block EntreprenurialController *blockSelf = self;
    NSDictionary *param =  [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"1",@"type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:ENTRE_LIST_DATA parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
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
    __block EntreprenurialController *blockSelf = self;
    [HTTPREQUEST_SINGLE getWithURLString:GROUND_SCROLL_IMAGE parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSString *imgURLString = responseDic[@"data"][@"entrepreneurship_img"];
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
    TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    vc.dataDic = dic;
    vc.title = @"创业资讯详情";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickToWebView:(NSString *)urlString andTitle:(NSString *)title{
    TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    vc.webUrl = urlString;
    vc.wayIn = @"创业";
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}
-(Entrepreneurial *)entreHeader{
    
        _entreHeader = [[NSBundle mainBundle] loadNibNamed:@"Entrepreneurial" owner:self options:nil][0];
        _entreHeader.cycleScrollview.imageURLStringsGroup = self.advertImageArray;
        _entreHeader.cycleScrollview.showPageControl = YES;
        [_entreHeader.cycleScrollview makeCorner:10];
        _entreHeader.frame = CGRectMake(0, 0, ScreenW, 513*kScale);
        __block EntreprenurialController *blockSelf = self;
    
        [_entreHeader.circlesView bk_whenTapped:^{
           [blockSelf clickToEntre:@"工商注册"];
        }];
        [_entreHeader.knowledgeView bk_whenTapped:^{
            [blockSelf clickToEntre:@"知识产权"];
        }];
        [_entreHeader.lawView bk_whenTapped:^{
             [blockSelf clickToEntre:@"法律服务"];
        }];
        [_entreHeader.moneyView bk_whenTapped:^{
            [blockSelf clickToEntre:@"财税服务"];
        }];
        [_entreHeader.zizhiView bk_whenTapped:^{
            [blockSelf clickToEntre:@"资质办理"];
        }];
        [_entreHeader.moreView bk_whenTapped:^{
            ChuangyeAllListController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"ChuangyeAllListController"];
            [self.navigationController pushViewController:vc animated:YES];
         
        }];
        [_entreHeader.clickCheckMoreView bk_whenTapped:^{
            EntreCheckMoreController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"EntreCheckMoreController"];
            vc.typeIndex = 1;
            [blockSelf.navigationController pushViewController:vc animated:YES];
        }];
    return _entreHeader;
}
-(void)clickToEntre:(NSString *)type{
    EntrepernurialAllListController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"EntrepernurialAllListController"];
    vc.typeString = type;
    vc.serviceType = @"创业宝典";
    [self.navigationController pushViewController:vc animated:YES];
}
@end

