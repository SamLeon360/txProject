//
//  CommerceNotifyController.m
//  TXProject
//
//  Created by Sam on 2019/1/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CommerceNotifyController.h"
#import "NotifyCell.h"
#import "TXWebViewController.h"
#import "MJRefresh.h"
#import "NotifyDetailController.h"
@interface CommerceNotifyController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *notifyArray;
@property (nonatomic) NSInteger nPage;
@end

@implementation CommerceNotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"社团通知";
    
   
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreNotifyData)];
    self.tableView.mj_footer = footer;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    if ((SHOW_WEB)) {
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(0, 0, 20, 20);
        [editBtn setBackgroundImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(clickToEdit) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
  
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.nPage = 1;
    [self getNotifyData];
}
-(void)clickToEdit{
    TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    vc.webUrl = [NSString stringWithFormat:@"%@%@",WEB_HOST_URL,@"secretary/send_notify/1"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getMoreNotifyData{
    self.nPage ++;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.default_commerce_id,@"commerce_id",[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"",@"notification_type",@"",@"notification_header" ,nil];
    __block CommerceNotifyController *blockSelf = self;
    [HTTPREQUEST_SINGLE allUserHeaderPostWithURLString:SH_NOTIFY_MESSAGE parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                blockSelf.nPage --;
                 [blockSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                 [blockSelf.tableView.mj_footer endRefreshing];
                  [blockSelf.notifyArray addObjectsFromArray:responseDic[@"data"]];
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
-(void)getNotifyData{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.default_commerce_id,@"commerce_id",[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"",@"notification_type",@"",@"notification_header" ,nil];
     __block CommerceNotifyController *blockSelf = self;
    [HTTPREQUEST_SINGLE allUserHeaderPostWithURLString:SH_NOTIFY_MESSAGE parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            blockSelf.notifyArray = [NSMutableArray arrayWithCapacity:0];
            [blockSelf.notifyArray addObjectsFromArray:responseDic[@"data"]];
        }
        [blockSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notifyArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyCell"];
    NSDictionary *dic = self.notifyArray[indexPath.row];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"notification_image"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.avatarImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    cell.title.text = dic[@"notification_header"];
    cell.scendTitle.text = dic[@"notification_header2"];
    NSString *sendTime = [dic[@"sending_time"] componentsSeparatedByString:@" "][0];
    cell.notifyTime.text = sendTime;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotifyDetailController *vc = [[UIStoryboard storyboardWithName:@"CommerceNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"NotifyDetailController"];
    
    NSDictionary *dic = self.notifyArray[indexPath.row];
    vc.notifyDic = dic;
    vc.localHtml = dic[@"notification_content"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
