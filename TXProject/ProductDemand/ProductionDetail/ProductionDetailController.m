//
//  ProductionDetailController.m
//  TXProject
//
//  Created by Sam on 2019/4/2.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProductionDetailController.h"
#import "ProDetailHeaderCell.h"
#import "ProdutionMsgCell.h"
#import "ProductionDescCell.h"
#import "ProCompanyCell.h"
#import "ProReplyCell.h"
#import "ChatViewController.h"

@interface ProductionDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIView *chatViewq;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *popIcon;
@property (nonatomic) NSArray *typeArray;
@property (nonatomic) NSArray *mainJobArray;
@property (nonatomic) NSDictionary *productDic;
@property (nonatomic) NSDictionary *companyDic;
@property (nonatomic) NSDictionary *commentsDic;
@property (nonatomic) NSArray *commentsArray;

@end

@implementation ProductionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] ];
    self.typeArray = @[@"全部", @"组件零部件",@"文化教育创意",@"酒店旅游餐饮",@"食品饮料",@"医疗保健",@"家电家居",@"冶金能源环保",@"化学化工",@"汽车工业",@"其他"];
    self.popIcon.userInteractionEnabled = YES;
    self.mainJobArray = @[@"包装印刷-包装",@"包装印刷-印刷",@"地产建材-地产开发",@"地产建材-建筑材料",@"地产建材-建筑监理及设计", @"法律咨询-法律咨询及服务", @"法律咨询-知识产权咨询及服务", @"纺织服饰-布匹", @"纺织服饰-服装", @"纺织服饰-箱包",@"工程贸易-工程施工",@"工程贸易-零售贸易",@"广告传媒-广告设计制作", @"广告传媒-文化传媒",@"广告传媒-新媒体广告",@"环保化工-环保检测治理", @"环保化工-生物化工",@"家电灯饰-灯饰配件",@"家电灯饰-灯饰照明",@"家电灯饰-家电配件",@"家电灯饰-家用电器",@"家具装饰-办公家具",@"家具装饰-家居用品", @"家具装饰-装饰工程",@"教育艺术-教育培训", @"教育艺术-文化艺术", @"金融财会-财会服务",@"金融财会-金融投资",@"酒店餐饮-餐饮服务",@"酒店餐饮-综合酒店",@"能源矿产-矿产开发",@"能源矿产-新能源产业",@"网络电子-电脑及配件",@"网络电子-软件工程",@"网络电子-网络技术",@"五金机械-机械装备",@"五金机械-模具铸造",@"五金机械-五金加工",@"物流运输-货物流通",@"物流运输-客运",@"医药保健-保健品",@"医药保健-医药销售",@"其他行业-其他行业"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.popIcon bk_whenTapped:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self GetDetailData];
}


-(void)editCompany{
     __block ProductionDetailController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_DETAIL_COMPANY parameters:@{@"enterprise_id":self.productDic[@"enterprise_id"]} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSArray *arr =  responseDic[@"data"];
            blockSelf.companyDic = arr.firstObject;
            [blockSelf GetComments];
        }
    } failure:^(NSError *error) {
        
    }];
   
}
-(void)GetComments{
    __block ProductionDetailController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectData[@"product_id"],@"demand_id",@"9",@"msg_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_PRODUCT_COMMENTS parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSArray *arr =responseDic[@"data"];
            blockSelf.commentsArray = arr;
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)GetDetailData{
    NSDictionary *param = @{@"product_id":self.selectData[@"product_id"]};
    __block ProductionDetailController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_PROJECT_DETAIL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSArray *arr = responseDic[@"data"];
            blockSelf.productDic = arr.firstObject;
            blockSelf.contactName.text = [blockSelf.productDic[@"member_name"] isKindOfClass:[NSNull class]]?@"":blockSelf.productDic[@"member_name"];
            __block ProductionDetailController *blockblockSelf = blockSelf;
            [blockSelf.phoneView bk_whenTapped:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",blockblockSelf.productDic[@"contacts_phone"]];
                UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [blockblockSelf.view addSubview:callWebview];
            }];
            [blockSelf.chatViewq bk_whenTapped:^{
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                ChatViewController *chat = [[ChatViewController alloc] init];
                TConversationCellData *data = [[TConversationCellData alloc] init];
                //会话ID
                data.convId =  [NSString stringWithFormat:@"%@",blockblockSelf.productDic[@"member_id"]];
                //会话类型
                data.convType = TConv_Type_C2C;
                //会话title
                data.title = blockblockSelf.productDic[@"member_name"];
                chat.conversation = data;
                [self.navigationController pushViewController:chat animated:YES];

            }];
            [blockSelf editCompany];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 527*kScale;
    }else if(indexPath.row == 1){
        
        return 227 - 34 + [CustomFountion getHeightLineWithString:[self.productDic[@"contacts_address"] isKindOfClass:[NSNull class]]?@"":self.productDic[@"contacts_address"] withWidth:267*kScale withFont:[UIFont systemFontOfSize:14]];
    }else if (indexPath.row == 2){
        return 150 - 48 + [CustomFountion getHeightLineWithString:[self.productDic[@"product_description"] isKindOfClass:[NSNull class]]?@"":self.productDic[@"product_description"] withWidth:368*kScale withFont:[UIFont systemFontOfSize:14]];
    }else if (indexPath.row == 3){
        return 114 - 20 + [CustomFountion getHeightLineWithString:[self.commentsDic[@"content"] isKindOfClass:[NSNull class]]?@"":self.commentsDic[@"content"] withWidth:366*kScale withFont:[UIFont systemFontOfSize:14]];
    }else{
        return 195;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ProDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailHeaderCell"];
        cell.productionNamew.text = self.productDic[@"product_name"];
        cell.endTime.text = self.productDic[@"put_off_shelves_time"];
//        cell.seeNumber.text = self.productDic[@""]
        return cell;
    }else if(indexPath.row == 1){
        ProdutionMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProdutionMsgCell"];
        cell.needNumber.text = [NSString stringWithFormat:@"%ld%@",[self.productDic[@"need_number"] isKindOfClass:[NSNull class]]?0:(long)[self.productDic[@"need_number"] integerValue],self.productDic[@"product_unit"]];
        cell.productionType.text = self.typeArray[[self.productDic[@"product_type"] isKindOfClass:[NSNull class]]?0:[self.productDic[@"product_type"] integerValue]];
        cell.area.text = [self.productDic[@"producing_area_require"] isKindOfClass:[NSNull class]]?@"":self.productDic[@"producing_area_require"];
        cell.detailAddress.text = [self.productDic[@"contacts_address"] isKindOfClass:[NSNull class]]?@"":self.productDic[@"contacts_address"];
        return cell;
    }else if (indexPath.row == 2){
        ProductionDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionDescCell"];
        cell.descLabel.text = [self.productDic[@"product_description"] isKindOfClass:[NSNull class]]?@"":self.productDic[@"product_description"];
        return cell;
    }else if (indexPath.row == 3){
        ProCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProCompanyCell"];
        [cell.companyIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,self.companyDic[@"enterprise_logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [cell.companyIcon setImage:[UIImage imageNamed:@"default_avatar"]];
            }
        }];
        cell.companyName.text = self.companyDic[@"enterprise_name"];
        cell.companyType.text = self.mainJobArray[[self.companyDic[@"business_scope"] isKindOfClass:[NSNull class]]?0:[self.companyDic[@"business_scope"] integerValue]];
        cell.companyAddress.text =  [self.companyDic[@"area"] isKindOfClass:[NSNull class]]?@"":self.companyDic[@"area"];
        return cell;
    }else {
        ProReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProReplyCell"];
        if (self.commentsArray.count != 0) {
            self.commentsDic = self.commentsArray.firstObject;
            cell.replyView.hidden = NO;
            cell.alertLabel.hidden = YES;
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@.jpg",@"https://app.tianxun168.com/uploads/mem_info/",self.commentsDic[@"sender_id"],self.commentsDic[@"sender_id"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    [cell.avatar setImage:[UIImage imageNamed:@"default_avatar"]];
                }
            }];
            cell.name.text = self.commentsDic[@"member_name"];
            cell.replyContent.text = self.commentsDic[@"content"];
            cell.time.text = [self.commentsDic[@"create_time"] componentsSeparatedByString:@" "].firstObject;
            [cell.replyBtn setText: @"查看全部留言"];
            cell.replyBtn.layer.borderWidth = 1;
            cell.replyBtn.layer.borderColor = [UIColor colorWithRGB:0x3F78BC].CGColor;
            [cell.replyBtn makeCorner: 23];
        }else{
            cell.replyView.hidden = YES;
            cell.alertLabel.hidden = NO;
        }
        return cell;
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    UIColor * color = AXYColorWithAlple(211, 211, 211, 1);
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(0.7, 0.7 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 128));
        [self.navigationView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:alpha] ];

    } else {
         [self.navigationView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0] ];
    }
    
}
@end
