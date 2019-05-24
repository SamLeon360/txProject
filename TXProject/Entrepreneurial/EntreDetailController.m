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
#import "OtherContactsController.h"
#import "ChatViewController.h"
#import "EntreCompanyMsgCell.h"
@interface EntreDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UIView *callView;
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
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
//        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//        conversationVC.conversationType = ConversationType_PRIVATE;
//        conversationVC.targetId = [NSString stringWithFormat:@"%@",blockSelf.detailDataDic[@"member_id"]];
//        conversationVC.title = blockSelf.detailDataDic[@"member_name"];
//        [blockSelf.navigationController pushViewController:conversationVC animated:YES];
        ChatViewController *chat = [[ChatViewController alloc] init];
        TConversationCellData *data = [[TConversationCellData alloc] init];
        //会话ID
        data.convId =  [NSString stringWithFormat:@"%@",blockSelf.detailDataDic[@"member_phone"]];
        //会话类型
        data.convType = TConv_Type_C2C;
        //会话title
        data.title =blockSelf.detailDataDic[@"member_name"];
        chat.conversation = data;
        [self.navigationController pushViewController:chat animated:YES];
    }];
    [self.callView bk_whenTapped:^{
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",blockSelf.detailDataDic[@"telephone"]];
        UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [blockSelf.view addSubview:callWebview];
    }];
    [self.likeView bk_whenTapped:^{
        [blockSelf SetupLike];
    }];
    
}
-(void)SetupLike{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"score",self.dataDic[@"service_id"],@"service_id", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_LIKE_SERVICE parameters:param withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == -1002) {
            [AlertView showYMAlertView:self.view andtitle:@"提交好评成功!"];
            [self.likeImage setImage:[UIImage imageNamed:@"IOS_Fabulous_Blue"]];
            NOTIFY_POST(@"getDataArrayByRefresh");
        }else{
            if ([responseDic[@"message"] isKindOfClass:[NSString class]]) {
                [AlertView showYMAlertView:self.view andtitle:responseDic[@"message"]];
            }
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    }];
}
-(void)GetDetailData{
    __block EntreDetailController *blockSelf = self;
    NSDictionary *param = @{@"service_id":self.dataDic[@"service_id"],@"_search_type":@"2"};
    [HTTPREQUEST_SINGLE postWithURLString:[self.typeString isEqualToString:@"综合服务"]?SH_SERVICE_DETAIL:SH_ENTRE_DETAIL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            NSDictionary *dic = responseDic[@"data"][0];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [newDic setObject:@"" forKey:key];
                }else{
                    [newDic setObject:obj forKey:key];
                }
            }];
            NSDictionary *addDic = responseDic[@"add"];
            [blockSelf.likeImage setImage: [addDic[@"has_scroce"] integerValue] == 0?[UIImage imageNamed:@"IOS_Fabulous_Gray"]:[UIImage imageNamed:@"IOS_Fabulous_Blue"]];
            blockSelf.detailDataDic = newDic;
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
        return 54 +[CustomFountion getHeightLineWithString:self.detailDataDic[@"service_desc"] withWidth:335*kScale withFont:[UIFont systemFontOfSize:15]];
    }else if (indexPath.row == 6){
        return 165;
    }else if (indexPath.row == 7){
        return 54 + [CustomFountion getHeightLineWithString:self.detailDataDic[@"enterprise_introduction"] withWidth:335*kScale withFont:[UIFont systemFontOfSize:15]];
    }else if (indexPath.row == 5){
        return 50 + [CustomFountion getHeightLineWithString:self.detailDataDic[@"address"] withWidth:335*kScale withFont:[UIFont systemFontOfSize:15]];
    }
    else{
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
        [cell bk_removeAllBlockObservers];
        [cell bk_whenTapped:^{
            NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
            if (indexP.row == 0) {
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.detailDataDic[@"telephone"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            }
        }];
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
        [cell bk_removeAllBlockObservers];
        return cell;
    }else if(indexPath.row == 6){
        EntreCompanyMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreCompanyMsgCell"];
        [cell.companyImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,self.detailDataDic[@"enterprise_logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [cell.companyImage setImage:[UIImage imageNamed:@"new_company_icon"]];
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
        cell.otherBtn.layer.borderWidth = 1;
        cell.otherBtn.layer.borderColor = [UIColor colorWithRGB:0x6C96C5].CGColor;
        [cell.otherBtn makeCorner:5];
        [cell.otherBtn bk_whenTapped:^{
            OtherContactsController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"OtherContactsController"];
            vc.dataDic = self.detailDataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }else{
        EntreServiceAndCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntreServiceAndCompanyCell"];
        cell.titleLabel.text = @"公司简介";
        cell.contentLabel.text = self.detailDataDic[@"enterprise_introduction"];
        return cell;
    }
    
}
@end
