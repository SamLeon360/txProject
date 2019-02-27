//
//  EntreDetailController.m
//  TXProject
//
//  Created by Sam on 2019/2/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EntreDetailController.h"
#import "EntreOneCell.h"
#import "EntreMessageCell.h"
#import "EntreServiceAndCompanyCell.h"
#import "EntreCompanyMsgCell.h"
@interface EntreDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UIView *callView;
@property (nonatomic) NSDictionary *detailDataDic;
@property (nonatomic) NSDictionary *serviceTypeDic;
@property (nonatomic) NSDictionary *entreTypeDic ;

@end

@implementation EntreDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.entreTypeDic =  @{@"1":@"工商注册",@"5":@"财税服务",@"8":@"知识产权",@"10":@"资质办理",@"18":@"法律服务",@"21":@"人力社保",@"25":@"场地服务",@"27":@"创业辅导",@"29":@"投融资",@"33":@"图文视频",@"36":@"视觉设计",@"37":@"市场传播",@"38":@"消防环保",@"39":@"物流快递",@"41":@" 创业信息"};
    self.serviceTypeDic = @{@"1":@"银行信贷",@"2":@"健康保健",@"3":@"活动策划",@"4":@"境外游学",@"5":@"保险代理",@"6":@"高端定制",@"7":@"商务翻译",@"8":@"公司搬迁",@"9":@"摄影摄像",@"10":@"车辆维护保养",@"11":@"商务出行",@"12":@"票卷服务"};
    [self GetDetailData];
    __block EntreDetailController *blockSelf = self;
    [self.chatView bk_whenTapped:^{
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = [NSString stringWithFormat:@"%@",blockSelf.detailDataDic[@"member_id"]];
        conversationVC.title = blockSelf.detailDataDic[@"member_name"];
        [blockSelf.navigationController pushViewController:conversationVC animated:YES];
    }];
    [self.callView bk_whenTapped:^{
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",blockSelf.detailDataDic[@"telephone"]];
        UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [blockSelf.view addSubview:callWebview];
    }];
}
-(void)GetDetailData{
    __block EntreDetailController *blockSelf = self;
    NSDictionary *param = @{@"service_id":self.dataDic[@"service_id"],@"_search_type":@"2"};
    [HTTPREQUEST_SINGLE postWithURLString:[self.typeString isEqualToString:@"综合服务"]?SH_SERVICE_DETAIL:SH_ENTRE_DETAIL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            blockSelf.detailDataDic = responseDic[@"data"][0];
            blockSelf.contactName.text = blockSelf.detailDataDic[@"member_name"];
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 405;
    }else if(indexPath.row == 1){
        return 89;
    }else if (indexPath.row == 6){
        return 165;
    }else if (indexPath.row == 7){
        return 90;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        EntreOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreOneCell"];
        cell.posterArray = [self.detailDataDic[@"service_img"] componentsSeparatedByString:@"|"];
        [cell setupCycleScrollview];
        cell.titleLabel.text = self.detailDataDic[@"service_title"];
        cell.priceLabel.text = self.detailDataDic[@"fee_mode"];
        cell.timeLabel.text = [NSString stringWithFormat:@"发布时间  %@",self.detailDataDic[@"add_time"]];
        cell.readLabel.text = [NSString stringWithFormat:@"浏览数 %@",self.detailDataDic[@"read_count"]];
        return cell;
    }else if (indexPath.row == 1){
        EntreServiceAndCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreServiceAndCompanyCell"];
        cell.contentLabel.text = self.detailDataDic[@"service_desc"];
        return cell;
    }else if (indexPath.row == 2){
        EntreMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreMessageCell"];
        cell.titleLabel.text = @"联系人";
        cell.contentLabel.text = self.detailDataDic[@"member_name"];
        [cell.cellImage setImage:[UIImage imageNamed:@"IOS_Phone_Blue"]];
        cell.cellImage.hidden = NO;
        return cell;
    }else if (indexPath.row == 3){
        EntreMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreMessageCell"];
        cell.titleLabel.text = @"服务类型";
        cell.contentLabel.text = self.serviceType;
        cell.cellImage.hidden = YES;
        return cell;
    }else if (indexPath.row == 4){
        EntreMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreMessageCell"];
        cell.titleLabel.text = @"所属商会";
        cell.contentLabel.text = self.detailDataDic[@"commerce_name"];
        cell.cellImage.hidden = YES;
        return cell;
    }else if (indexPath.row == 5){
        EntreMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreMessageCell"];
        cell.titleLabel.text = @"公司地址";
        cell.contentLabel.text = self.detailDataDic[@"address"];
        [cell.cellImage setImage:[UIImage imageNamed:@"IOS_Place"]];
        cell.cellImage.hidden = NO;
        return cell;
    }else if(indexPath.row == 6){
        EntreCompanyMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreCompanyMsgCell"];
        [cell.companyImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,self.detailDataDic[@"member_avatar"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [cell.companyImage setImage:[UIImage imageNamed:@"default_avatar"]];
            }
        }];
        cell.companyName.text = self.detailDataDic[@"enterprise_name"];
        [cell.callBtn bk_whenTapped:^{
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.detailDataDic[@"telephone"]];
            UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];
        cell.callBtn.layer.borderWidth = 1;
        cell.callBtn.layer.borderColor = [UIColor colorWithRGB:0x6C96C5].CGColor;
        [cell.callBtn makeCorner:5];
        
        return cell;
    }else{
        EntreServiceAndCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreServiceAndCompanyCell"];
        cell.titleLabel.text = @"公司简介";
        cell.contentLabel.text = self.detailDataDic[@"enterprise_introduction"];
        return cell;
    }
    
}
@end
