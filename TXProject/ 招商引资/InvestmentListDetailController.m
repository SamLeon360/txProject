//
//  InvestmentListDetailController.m
//  TXProject
//
//  Created by Sam on 2019/3/5.
//  Copyright © 2019 sam. All rights reserved.
//

#import "InvestmentListDetailController.h"
#import "InvestmentHeaderView.h"
#import "InvestCheckMoreCell.h"
#import "InvestmentCheckMoreCell.h"
#import "InvestMsgCell.h"
#import "InvestUserMsgCell.h"
@interface InvestmentListDetailController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSDictionary *detailDataDic;
@property (nonatomic) NSMutableArray *messageArray;
@property (nonatomic) InvestmentHeaderView *headerView;
@property (nonatomic) NSArray *projectTypeArray ;
@property (nonatomic) BOOL oneCheckMore;
@property (nonatomic) BOOL twoCheckMore;
@property (nonatomic) CGFloat oneCheckHeight;
@property (nonatomic) CGFloat twoCheckHeight;
@property (nonatomic) UIWebView * callWebview;
@end

@implementation InvestmentListDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.oneCheckMore = NO;
    self.twoCheckMore = NO;
    self.contactBtn.tag = [self.dataDic[@"type"] integerValue];
    if (self.contactBtn.tag == 1) {
        [self.contactBtn setTitle:@"解除投资意向" forState:UIControlStateNormal];
    }else{
        [self.contactBtn setTitle:@"有投资意向，请与我联系" forState:UIControlStateNormal];
    }
   
    self.title = @"招商详情";
    self.projectTypeArray = @[ @"全部",@"园区建设",@"基础设施",@"农牧农副",@"工业制造",@"医药化工",@"文化旅游",@"能源矿产",@"金融投资",@"商贸物流",@"生物医药",@"现代服务业",@"大健康医药",@"健康养老",@"医疗服务业",@"科教文卫",@"科教文卫",@"高新科技",@"设施管理",@"其他"];
    self.messageArray = [NSMutableArray arrayWithCapacity:0];
    [self getInvestDetail];
     [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)getInvestDetail {
    __block InvestmentListDetailController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"projects_id"],@"projects_id",@"1",@"is_auth", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_INVESTMEMT_DETAIL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            NSDictionary *dic = responseDic[@"data"];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [newDic setObject:@"" forKey:key];
                }else{
                    [newDic setObject:obj forKey:key];
                }
            }];
            blockSelf.detailDataDic = newDic;
            blockSelf.tableView.tableHeaderView = blockSelf.headerView;
            [blockSelf.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
    [HTTPREQUEST_SINGLE postWithURLString:SH_SHOW_MESSAGE parameters:@{@"news_id":self.dataDic[@"projects_id"]} withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSArray *arr = responseDic[@"data"];
            for (NSDictionary *dic in arr) {
                NSDictionary *otherParam = [[NSDictionary alloc] initWithObjectsAndKeys:@[dic[@"receiver_author"],dic[@"sender_author"]],@"ids", nil];
                [HTTPREQUEST_SINGLE postWithURLString:SH_GET_MEMBERS_MESSAGE parameters:otherParam withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
                    if ([responseDic[@"code"] integerValue] == 0) {
                        NSDictionary *respDic = responseDic[@"data"];
                        NSDictionary *finalDic = [[NSDictionary alloc] initWithObjectsAndKeys:respDic[[NSString stringWithFormat:@"%ld",[dic[@"sender_author"] integerValue]]],@"name",dic[@"content"],@"content", nil];
                        [self.messageArray addObject:finalDic];
                        [blockSelf.tableView reloadData];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }
    } failure:^(NSError *error) {
        
    }];//
    
    [self.contactBtn bk_whenTapped:^{
        NSDictionary *paramDic = blockSelf.contactBtn.tag == 1?[[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"projects_name"],@"interested_name",self.dataDic[@"projects_id"],@"projects_id",@"1",@"type", nil]:[[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"projects_id"],@"projects_id",@"1",@"type", nil];
        [HTTPREQUEST_SINGLE postWithURLString:blockSelf.contactBtn.tag==1?SH_ADD_COLLECTION:SH_DELETE_COLLECTION parameters:paramDic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
            if ([responseDic[@"code"] integerValue] == -1002) {
                [AlertView showYMAlertView:self.view andtitle:@"操作成功"];
                if (blockSelf.contactBtn.tag == 1) {
                    blockSelf.contactBtn.tag = 2;
                    [blockSelf.contactBtn setTitle:@"解除投资意向" forState:UIControlStateNormal];
                }else{
                    blockSelf.contactBtn.tag = 1;
                    [blockSelf.contactBtn setTitle:@"有投资意向,请与我联系" forState:UIControlStateNormal];
                }
                NOTIFY_POST(@"getinvestmentArrayByRefresh");
            }
        } failure:^(NSError *error) {
            
        }];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count + 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.oneCheckMore) {
         
            return self.oneCheckHeight+87;
        }
        return 210;
    }else if (indexPath.row == 1){
        if (self.twoCheckMore) {
           
            return self.twoCheckHeight+87;
        }
        return 210;
    }else if (indexPath.row == 2){
        if ([CustomFountion getHeightLineWithString:[NSString stringWithFormat:@"%@ %@",[self.detailDataDic[@"projects_venue"] stringByReplacingOccurrencesOfString:@"|" withString:@""],self.detailDataDic[@"projects_venue2"]] withWidth:215*kScale withFont:[UIFont systemFontOfSize:14]] <50) {
            return 500;
        }else{
            return 450 + [CustomFountion getHeightLineWithString:[NSString stringWithFormat:@"%@ %@",[self.detailDataDic[@"projects_venue"] stringByReplacingOccurrencesOfString:@"|" withString:@""],self.detailDataDic[@"projects_venue2"]] withWidth:215*kScale withFont:[UIFont systemFontOfSize:14]];
        }
        
    }else{
        return 44;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        InvestmentCheckMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentCheckMoreCell"];
        cell.titleLabel.text = @"项目详细介绍";
        if (self.detailDataDic != nil) {
            
            WKWebView *webView ;
            if (cell.webcontentView.subviews.count <= 0) {
                webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,cell.webcontentView.frame.size.width,self.oneCheckMore?self.oneCheckHeight:83)];
            }else{
                webView = cell.webcontentView.subviews.firstObject;
                webView.frame = CGRectMake(0, 0,cell.webcontentView.frame.size.width,self.oneCheckMore?self.oneCheckHeight:83);
            }
            cell.webcontentView.frame = CGRectMake(0, 41,cell.webcontentView.frame.size.width,self.oneCheckMore?self.oneCheckHeight:83);
           
            
            [webView setNavigationDelegate:self];
            webView.clipsToBounds = YES;
            webView.UIDelegate = self;
            [webView loadHTMLString:self.detailDataDic[@"project_details"] baseURL:nil];
            if (cell.webcontentView.subviews.count <= 0) {
                [cell.webcontentView addSubview:webView];
            }
        }
        [cell.checkMoreLabel bk_removeAllBlockObservers];
        [cell.checkMoreLabel bk_whenTapped:^{
            WKWebView *webView = cell.webcontentView.subviews.firstObject;
            self.oneCheckMore = !self.oneCheckMore;
            cell.checkMoreLabel.text = self.oneCheckMore?@"收起":@"查看更多";
            self.oneCheckHeight = self.oneCheckMore?webView.scrollView.contentSize.height+87:0;
             [cell.webAutoHeight setConstant:self.oneCheckMore?webView.scrollView.contentSize.height:83];
            [self.tableView reloadData];
            [self.view layoutIfNeeded];
        }];
        return cell;
    }else if (indexPath.row == 1){
        InvestmentCheckMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentCheckMoreCell"];
        cell.titleLabel.text = @"项目前景分析";
        if (self.detailDataDic != nil) {
  
            WKWebView *webView;
            if (cell.webcontentView.subviews.count <= 0) {
                webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,cell.webcontentView.frame.size.width,self.twoCheckMore?self.twoCheckHeight:83)];
            }else{
                webView = cell.webcontentView.subviews.firstObject;
                webView.frame = CGRectMake(0, 0,cell.webcontentView.frame.size.width,self.twoCheckMore?self.twoCheckHeight:83);
            }
            cell.webcontentView.frame = CGRectMake(0, 41,cell.webcontentView.frame.size.width,self.twoCheckMore?self.twoCheckHeight:83);
            [cell.webAutoHeight setConstant:self.twoCheckMore?self.twoCheckHeight:83];
        [webView setNavigationDelegate:self];
        webView.clipsToBounds = YES;
        webView.UIDelegate = self;
        [webView loadHTMLString:self.detailDataDic[@"prospect_analysis"] baseURL:nil];
            if (cell.webcontentView.subviews.count <= 0) {
                [cell.webcontentView addSubview:webView];
            }
        }
        [cell.checkMoreLabel bk_removeAllBlockObservers];
        [cell.checkMoreLabel bk_whenTapped:^{
            
            WKWebView *webView = cell.webcontentView.subviews.firstObject;
            self.twoCheckMore = !self.twoCheckMore;
             cell.checkMoreLabel.text = self.twoCheckMore?@"收起":@"查看更多";
            self.twoCheckHeight = self.twoCheckMore?webView.scrollView.contentSize.height+87:0;
            [cell.webAutoHeight setConstant:self.twoCheckMore?webView.scrollView.contentSize.height:83];
            [self.tableView reloadData];
            [self.view layoutIfNeeded];
        }];
        return cell;
    }else if(indexPath.row == 2){
        InvestMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestMsgCell"];
        cell.contactLabel.text = self.detailDataDic[@"contacts"];
        cell.jobLabel.text = [self.detailDataDic[@"job_title"] isKindOfClass:[NSNull class]]?@"":self.detailDataDic[@"job_title"];
        cell.callNumberLabel.text = self.detailDataDic[@"phone_number"];
        cell.phoneLabel.text = [self.detailDataDic[@"cell_phone"] isKindOfClass:[NSNull class]]?@"":self.detailDataDic[@"cell_phone"];
        cell.emailLabel.text = [self.detailDataDic[@"email"] isKindOfClass:[NSNull class]]?@"":self.detailDataDic[@"email"];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@",[self.detailDataDic[@"projects_venue"] stringByReplacingOccurrencesOfString:@"|" withString:@""],self.detailDataDic[@"projects_venue2"]];
        cell.messageTF.layer.borderWidth = 1;
        cell.messageTF.layer.borderColor = [UIColor colorWithRGB:0XEDEDED].CGColor;
        [cell.callNumberView bk_whenTapped:^{
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.detailDataDic[@"phone_number"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];
        [cell.phoneView bk_whenTapped:^{
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.detailDataDic[@"cell_phone"]];
            UIWebView * callWebview1 = [[UIWebView alloc] init];
            [callWebview1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview1];
        }];
        [cell.submitBtn bk_whenTapped:^{
            NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:cell.messageTF.text,@"content",self.dataDic[@"projects_id"],@"news_id",self.detailDataDic[@"member_id"],@"receiver_author",@"",@"son_id" ,nil];
            [HTTPREQUEST_SINGLE postWithURLString:SH_ADD_MESSAGE parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
                if ([responseDic[@"code"] integerValue] == -1002) {
                    [AlertView showYMAlertView:self.view andtitle:@"留言成功"];
                    cell.messageTF.text = @"";
                    [self getInvestDetail];
                }else{
                    [AlertView showYMAlertView:self.view andtitle:@"留言失败"];
                }
            } failure:^(NSError *error) {
                [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
            }];
        }];
        return cell;
    }else{
        InvestUserMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestUserMsgCell"];
        NSDictionary *dic = self.messageArray[indexPath.row - 3];
        NSString *name = dic[@"name"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",name,dic[@"content"]]];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0x437AFA] range: NSMakeRange(0, name.length)];
        cell.contentLabel.attributedText = attrString;
        
        return cell;
    }
}
-(InvestmentHeaderView *)headerView{
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"InvestmentView" owner:self options:nil][2];
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *arr = [self.detailDataDic[@"picture"] componentsSeparatedByString:@"|"];
        for (int i = 0; i < arr.count ; i ++) {
            [imageArray addObject: [NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,arr[i]]];
        }
        _headerView.investImage.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _headerView.investImage.imageURLStringsGroup = imageArray;
        _headerView.investImage.showPageControl = NO;
        [_headerView.investImage setAutoScrollTimeInterval:5];
        _headerView.investImage.autoScroll = imageArray.count >1?YES:NO;
        _headerView.investImage.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _headerView.posterLabel.text = self.detailDataDic[@"member_name"];
    _headerView.timeLabel.text = [self.detailDataDic[@"release_time"] componentsSeparatedByString:@" "][0];
    _headerView.projectType.text = self.projectTypeArray[[self.detailDataDic[@"projects_type"] integerValue]];
    _headerView.cooperationLabel.text = self.detailDataDic[@"cooperation_method"];
    _headerView.progressLabel.text = self.detailDataDic[@"complete_schedule"];
    _headerView.budgetLabel.text = [NSString stringWithFormat:@"%@亿元",self.detailDataDic[@"investment_amount"]];
    _headerView.titleLabel.text = self.detailDataDic[@"projects_name"];
    return _headerView;
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"%@",URL);
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
@end
