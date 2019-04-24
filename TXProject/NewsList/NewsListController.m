//
//  NewsListController.m
//  TXProject
//
//  Created by Sam on 2019/2/14.
//  Copyright © 2019 sam. All rights reserved.
//

#import "NewsListController.h"
#import "NewsListCell.h"
#import "MJRefresh.h"
#import "NewsDetailController.h"
@interface NewsListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *newsListArray;
@property (nonatomic) NSInteger nPage;
@end

@implementation NewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"商头条";
    [self getCommerceArray];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataArrayByMore)];
    self.tableView.mj_footer = footer;
    [self.searchBtn bk_whenTapped:^{
        [self getCommerceArray];
    }];
}
-(void)getCommerceArray{
    __block NewsListController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",self.searchTF.text,@"deal_name",@"1",@"page",@"",@"ios",@"",@"id", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_GET_NEWS_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            blockSelf.newsListArray = [NSMutableArray arrayWithCapacity:0];
            blockSelf.newsListArray = responseDic[@"data"];
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getDataArrayByMore{
    self.nPage ++;
//    NSString *name =self.searchTF.text.length==0?@"":self.searchTF.text;
    __block NewsListController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",self.searchTF.text,@"deal_name",[NSString stringWithFormat:@"%ld",self.nPage],@"page",@"",@"ios",@"",@"id", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_GET_NEWS_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            [blockSelf.tableView.mj_footer endRefreshing];
            [blockSelf.newsListArray addObjectsFromArray:responseDic[@"data"]] ;
            [blockSelf.tableView reloadData];
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            self.nPage --;
            [blockSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        self.nPage -- ;
        [blockSelf.tableView.mj_footer endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.newsListArray[indexPath.row];
    NewsDetailController *vc = [[UIStoryboard storyboardWithName:@"NewsList" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsDetailController"];
    vc.newsId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    vc.newsDic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewsListCell"];
    NSDictionary *dic = self.newsListArray[indexPath.row];
    cell.titleLabel.text = dic[@"headlines"];
    cell.contentLabel.text = dic[@"headlines2"];
    NSString *timeString = dic[@"publish_time"];
    cell.timeLabel.text = [timeString componentsSeparatedByString:@" "][0];
    [cell.newsImageView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"headlines_img"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.newsImageView setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
