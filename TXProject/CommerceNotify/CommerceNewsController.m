//
//  CommerceNewsController.m
//  TXProject
//
//  Created by Sam on 2019/1/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CommerceNewsController.h"
#import "NotifyCell.h"
#import "MJRefresh.h"
#import "NotifyDetailController.h"
#import "ComNewsDetailController.h"
#import "TXWebViewController.h"
@interface CommerceNewsController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger nPage;
@property (nonatomic) NSMutableArray *newsArray;
@end

@implementation CommerceNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"社团新闻";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreNotifyData)];
    self.tableView.mj_footer = footer;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
//        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        editBtn.frame = CGRectMake(0, 0, 20, 20);
//        [editBtn setBackgroundImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
//        [editBtn addTarget:self action:@selector(clickToEdit) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
//        self.navigationItem.rightBarButtonItem = rightItem;
    

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidLayoutSubviews{
    self.nPage = 1;
    [self getNotifyData];
}
-(void)clickToEdit{
//    TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
//    vc.webUrl = [NSString stringWithFormat:@"%@add_update_news///1",WEB_HOST_URL];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getNotifyData{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.default_commerce_id,@"commerce_id",@"1",@"page",@"",@"news_types",@"",@"news_headlines",@"1",@"allow_publish" ,nil];
    __block CommerceNewsController *blockSelf = self;
    [HTTPREQUEST_SINGLE allUserHeaderPostWithURLString:SH_LIST_NEWS parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            blockSelf.newsArray = [NSMutableArray arrayWithCapacity:0];
            [blockSelf.newsArray addObjectsFromArray:responseDic[@"data"]];
        }
        [blockSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)getMoreNotifyData{
    self.nPage ++;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.default_commerce_id,@"commerce_id",[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"",@"news_types",@"",@"news_headlines",@"1",@"allow_publish"  ,nil];
    __block CommerceNewsController *blockSelf = self;
    [HTTPREQUEST_SINGLE allUserHeaderPostWithURLString:SH_NOTIFY_MESSAGE parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                blockSelf.nPage --;
                [blockSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [blockSelf.tableView.mj_footer endRefreshing];
                [blockSelf.newsArray addObjectsFromArray:responseDic[@"data"]];
                [blockSelf.tableView.mj_footer endRefreshing];
            }
            
        }else{
            blockSelf.nPage --;
            [blockSelf.tableView.mj_footer endRefreshing];
        }
        [blockSelf.tableView reloadData];
    } failure:^(NSError *error) {
        blockSelf.nPage--;
        [blockSelf.tableView.mj_footer endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyCell"];
    NSDictionary *dic = self.newsArray[indexPath.row];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"new_title_photo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.avatarImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    cell.title.text = dic[@"news_headlines"];
    cell.scendTitle.text = dic[@"news_headlines2"];
    NSString *sendTime = [dic[@"modify_time"] componentsSeparatedByString:@" "][0];
    cell.notifyTime.text = sendTime;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ComNewsDetailController *vc = [[UIStoryboard storyboardWithName:@"CommerceNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"ComNewsDetailController"];
    
    NSDictionary *dic = self.newsArray[indexPath.row];
    vc.notifyDic = dic;
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
