//
//  EntreCheckMoreController.m
//  TXProject
//
//  Created by Sam on 2019/4/11.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EntreCheckMoreController.h"
#import "EntreCheckMoreCell.h"
#import "MJRefresh.h"
#import "NewsDetailController.h"
@interface EntreCheckMoreController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger nPage;
@end

@implementation EntreCheckMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.typeIndex==1?@"创头条":@"行业热点";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self GetDataNet];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetDataNetMore)];
    self.tableView.mj_footer = footer;
}
-(void)GetDataNet{
    self.nPage = 1;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.nPage],@"page",[NSString stringWithFormat:@"%ld",self.typeIndex],@"type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_LIST_CHUANGYE parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            self.dataArray = [NSMutableArray arrayWithCapacity:0];
            [self.dataArray addObjectsFromArray: responseDic[@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
    
    }];
}

-(void)GetDataNetMore{
    self.nPage ++;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",[NSString stringWithFormat:@"%ld",self.typeIndex],@"type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_LIST_CHUANGYE parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDic[@"code"] integerValue] == 1) {
              NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.dataArray addObjectsFromArray: responseDic[@"data"]];
            [self.tableView reloadData];
            
        }else{
            self.nPage -- ;
          
        
        }
    } failure:^(NSError *error) {
        self.nPage -- ;
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntreCheckMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreCheckMoreCell"];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.title.text = dic[@"headlines"];
    NSArray *timeArr = [dic[@"publish_time"] componentsSeparatedByString:@" "];
    cell.time.text = timeArr.firstObject;
    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?imageView2/2/w/200/h/200",AVATAR_HOST_URL,dic[@"headlines_img"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.cellImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    [cell.cellContentView makeCorner:5];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailController *vc = [[UIStoryboard storyboardWithName:@"NewsList" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsDetailController"];
    NSDictionary *dic = self.dataArray[indexPath.row];
    vc.title = [NSString stringWithFormat:@"%@详情",self.title];
    vc.typeIndex = 1;
    vc.newsId = dic[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
