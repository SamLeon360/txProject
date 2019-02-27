//
//  AddServiceFormController.m
//  TXProject
//
//  Created by Sam on 2019/2/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "AddServiceFormController.h"
#import <ZLPhotoActionSheet.h>
#import <IQKeyboardManager.h>
#import "PayServiceController.h"
@interface AddServiceFormController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *uploadIamge;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *serviceTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *companyAddTF;
@property (weak, nonatomic) IBOutlet UITextField *detailAddTF;
@property (weak, nonatomic) IBOutlet UITextField *contactNameTF;
@property (weak, nonatomic) IBOutlet UITextView *companyIntrTF;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *QQTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UILabel *serviceType;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (nonatomic) NSString *serviceId;
@property (nonatomic) NSDictionary *selectTypeData;
@property (nonatomic) UIPickerView *areaPickerView;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (nonatomic) UIButton *pickSureBtn;
@property (nonatomic) NSDictionary *mineDic;
@property (nonatomic) NSDictionary *paramDic;
@end

@implementation AddServiceFormController
- (IBAction)clickToUpload:(id)sender {
    NSString *urlString = [self.typeString isEqualToString:@"创业宝典"]?SH_CHECK_PAY_SERVICE:SH_CHECK_PAY_ZONGHE;
    [HTTPREQUEST_SINGLE postWithURLString:urlString parameters:@{@"service_type":[NSString stringWithFormat:@"%ld",(long)self.typeIndex]} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            if ([responseDic[@"data"] integerValue] == 0) {
                PayServiceController *VC = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"PayServiceController"];
                VC.paramDic = self.paramDic;
                VC.uploadIamge = self.uploadIamge.image;
                VC.typeString = self.typeString;
                VC.dataDic = self.paramDic;
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                [self uploadData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
  
    
    
}
-(void)uploadData{
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self.mineDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [parDic setObject:obj forKey:key];
    }];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *add_time = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
//    [NSString stringWithFormat:@"%ld",self.typeIndex],@"service_id"
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.titleTF.text,@"service_title",self.serviceTF.text,@"service_desc",add_time,@"add_time",self.contactNameTF.text,@"member_name",USER_SINGLE.default_commerce_id==nil?@"":USER_SINGLE.default_commerce_id,@"commerce_id",self.serviceId,@"service_type",self.companyTF.text,@"enterprise_name",self.contactPhoneTF.text,@"telephone",self.priceTF.text,@"fee_mode",self.emailTF.text,@"email",self.QQTF.text,@"qq",self.detailAddTF.text,@"address",self.companyAddTF.text,@"area",self.companyIntrTF.text,@"enterprise_introduction",@"",@"honor_certificate",@"",@"qualification_certificate",@"",@"weixin",@"",@"fax",@"",@"majors",@"",@"graduate_institutions",USER_SINGLE.member_id,@"member_id",nil];
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [parDic setObject:obj forKey:key];
    }];
    if ([self.typeString isEqualToString:@"综合服务"]) {
        [parDic removeObjectForKey:@"service_id"];
    }
    NSString *fee = self.priceTF.text;
    [parDic setObject:fee forKey:@"fee_mode"];
    self.paramDic = parDic;
    
}
-(void)getMineMessage{
    [HTTPREQUEST_SINGLE postWithURLString:SH_LOAD_INFO parameters:@{@"_search_type":@"1"} withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSDictionary *dic = responseDic[@"data"];
            self.mineDic = dic;
            self.contactNameTF.text = dic[@"member_name"];
//            self.companyAddTF.text = [dic[@"area"] stringByReplacingOccurrencesOfString:@"|" withString:@""];
            self.detailAddTF.text = [dic[@"address"] isKindOfClass:[NSNull class]]?@"":dic[@"address"];
            self.companyTF.text = [dic[@"enterprise_name"] isKindOfClass:[NSNull class]]?@"":dic[@"enterprise_name"];
            self.companyIntrTF.text = [dic[@"enterprise_introduction"] isKindOfClass:[NSNull class]]?@"":dic[@"enterprise_introduction"];
            self.contactPhoneTF.text= [dic[@"telephone"] isKindOfClass:[NSNull class]]?@"":dic[@"telephone"];
            if ([dic[@"enterprise_name"] isKindOfClass:[NSNull class]]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return ;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"入驻平台申请";
    [self getMineMessage];
    [self.uploadBtn makeCorner: 5];
    NOTIFY_ADD(uploadData, @"uploadServiceData");
  NSDictionary *dic =  @{
    @"1":@{@"公司注册":@"1",@"注册地址服务":@"2",@"公司变更":@"3"},
    @"5":@{@"代理记账":@"5",@"税务代办":@"6",@"财务审计":@"7"},
    @"8":@{@"商标注册":@"8",@"软件著作权":@"9",@"专利":@"10"},
    @"10":@{@"经营许可证":@"10",@"其他行业许可证":@"11",@"高新企业":@"12"},
    @"18":@{@"法律顾问":@"18",@"项目合规":@"19",@"合同":@"20",@"股权期权":@"21"},
    @"21":@{@"人才培训":@"21",@"商业保险":@"22",@"社保服务":@"23"},
    @"25":@{@"场地租赁":@"25",@"创业基地":@"26",@"办公设施":@"27"},
    @"27":@{@"创业培训":@"27",@"创业导师":@"28",@"创业顾问":@"29"},
    @"29":@{@"投资机构":@"29",@"投资人":@"30"},
    @"33":@{@"视频策划制作":@"33",@"图文策划制作":@"34"},
    @"36":@{@"商标设计":@"36",@"平面广告设计":@"37"},
    @"37":@{@"营销":@"38",@"推广":@"39",@"广告发布":@"40",@"新媒体":@"41"},
    @"38":@{@"消防安监":@"38",@"环保环评":@"39"},
    @"39":@{@"物流服务":@"39",@"快速服务":@"40"},
    @"41":@{@"连锁加盟":@"41",@"项目转让":@"42",@"创业项目":@"43"}};
    if ([self.typeString isEqualToString:@"创业宝典"]) {
        self.selectTypeData = dic[[NSString stringWithFormat:@"%ld",(long)self.typeIndex]];
    }else{
        self.selectTypeData = @{@"融资信贷":@"1",@"科技创新":@"2",
                                    @"健康体检":@"3",
                                    @"活动策划":@"4",
                                    @"高端定制":@"5",
                                    @"车辆保养":@"6",
                                    @"展会展览":@"7",
                                    @"住宿餐饮":@"8",
                                    @"涉外服务":@"9",
                                    @"项目申报":@"10",
                                    @"房地产":@"11",
                                    @"商务翻译":@"12",
                                    @"公司搬迁":@"13",
                                    @"摄影摄像":@"14",
                                @"汽车租赁":@"15"};
        self.serviceType.userInteractionEnabled = NO;
        [self.selectTypeData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj integerValue]==self.typeIndex) {
                self.serviceType.text= key;
            }
        }];
    }
    [IQKeyboardManager sharedManager].enable = YES;
    [self setupClickAction];
    [self setupViews];
}
-(void)setupViews{
    self.serviceTF.layer.borderWidth = 1;
    self.serviceTF.layer.borderColor =[UIColor colorWithRGB:0xf2f2f2].CGColor;
    self.companyIntrTF.layer.borderWidth = 1;
    self.companyIntrTF.layer.borderColor =[UIColor colorWithRGB:0xf2f2f2].CGColor;
}
-(void)setupClickAction{
    
    self.areaPickerView.delegate = self;
    self.areaPickerView.dataSource = self;
    [[UIApplication sharedApplication].keyWindow  addSubview:self.areaPickerView];
    self.pickSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenH-340, ScreenW, 40)];
    [self.pickSureBtn setBackgroundColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.pickSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.pickSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pickSureBtn.hidden = YES;
    __block AddServiceFormController *blockSelf = self;
    [self.pickSureBtn bk_whenTapped:^{
        blockSelf.areaPickerView.hidden = YES;
        blockSelf.pickSureBtn.hidden = YES;
    }];
    [[UIApplication sharedApplication].keyWindow  addSubview:self.pickSureBtn];
 
    [self.uploadIamge bk_whenTapped:^{
        ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
        
        //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
        ac.configuration.maxSelectCount = 1;
        ac.configuration.maxPreviewCount = 10;
        ac.configuration.allowMixSelect = NO;
        
        //如调用的方法无sender参数，则该参数必传
        ac.sender = blockSelf;
        __block AddServiceFormController *bblockSelf = blockSelf;
        //选择回调
        [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            [bblockSelf.uploadIamge setImage:images[0]];
        }];
        
        //调用相册
        [ac showPreviewAnimated:YES];
    }];
    [self.serviceType bk_whenTapped:^{
        blockSelf.areaPickerView.hidden = NO;
        blockSelf.pickSureBtn.hidden = NO;
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    [view setBackgroundColor:[UIColor colorWithRGB:0xededed]];
    return view;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.selectTypeData.allKeys.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = self.selectTypeData.allKeys[row];
    return title;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     NSString *title = self.selectTypeData.allKeys[row];
    self.serviceId = self.selectTypeData[title];
    self.serviceType.text = title;
}
-(UIPickerView *)areaPickerView{
    if (_areaPickerView == nil) {
        _areaPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenH-300, ScreenW, 300)];
        _areaPickerView.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
        _areaPickerView.hidden = YES;
    }
    return  _areaPickerView;
}
@end
