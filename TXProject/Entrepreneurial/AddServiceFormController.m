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
#import "NewEditAlertView.h"
#import "SHEditCommidityCameraController.h"
@interface AddServiceFormController ()<UIPickerViewDataSource,UIPickerViewDelegate,SHEditCommidityCameraDelegate>
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
@property (weak, nonatomic) IBOutlet UIView *facePriceView;
@property (weak, nonatomic) IBOutlet UIImageView *selImage;
@property (nonatomic) UIView *typeBgView;
@property (nonatomic) ZLPhotoActionSheet *ac ;
@end

@implementation AddServiceFormController
{
    NewEditAlertView *alertView;
}
- (IBAction)clickToUpload:(id)sender {
    [self uploadData];
    NSString *urlString = [self.typeString isEqualToString:@"创业宝典"]?SH_CHECK_PAY_SERVICE:SH_CHECK_PAY_ZONGHE;
    [HTTPREQUEST_SINGLE postWithURLString:urlString parameters:@{@"service_type":[NSString stringWithFormat:@"%ld",(long)self.typeIndex]} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            if ([responseDic[@"data"] integerValue] == 0) {
                PayServiceController *VC = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"PayServiceController"];
                VC.paramDic = self.paramDic;
                VC.uploadIamge = self.uploadIamge.image;
                VC.typeString = self.typeString;
                VC.dataDic = @{@"service_type":[NSString stringWithFormat:@"%d",[self.typeString isEqualToString:@"创业宝典"]?2:1]};
                VC.serviceDic =  @{@"service_type":[NSString stringWithFormat:@"%ld",(long)self.typeIndex]};
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                [self uploadDataMore];
            }
        }else{
            [AlertView showYMAlertView:self.view andtitle: responseDic[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
  
    
    
}
-(void)uploadData{
    if (self.titleTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请填写标题"];
        return;
    }
    if (self.serviceTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请填写服务介绍"];
        return;
    }
    if (self.companyTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请填写公司名称"];
        return;
    }
    if (self.companyAddTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请填写公司地址"];
        return;
    }
    if (self.priceTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请填写价格"];
        return;
    }
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self.mineDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [parDic setObject:obj forKey:key];
    }];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *add_time = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
//    [NSString stringWithFormat:@"%ld",self.typeIndex],@"service_id"
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.titleTF.text,@"service_title",self.serviceTF.text,@"service_desc",add_time,@"add_time",self.contactNameTF.text,@"member_name",USER_SINGLE.default_commerce_id==nil?@"":USER_SINGLE.default_commerce_id,@"commerce_id",self.serviceId,@"service_type",self.companyTF.text,@"enterprise_name",self.contactPhoneTF.text,@"telephone",self.priceTF.text,@"fee_mode",self.emailTF.text,@"email",self.QQTF.text,@"qq",self.detailAddTF.text,@"address",self.companyAddTF.text,[self.typeString isEqualToString:@"创业宝典"]?@"area":@"search_area",self.companyIntrTF.text,@"enterprise_introduction",@"",@"honor_certificate",@"",@"qualification_certificate",@"",@"weixin",@"",@"fax",@"",@"majors",@"",@"graduate_institutions",USER_SINGLE.member_id,@"member_id",nil];
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

-(void)uploadDataMore {
    [HTTPREQUEST_SINGLE uploadImageArrayWithUrlStr:[self.typeString isEqualToString:@"创业宝典"]?SH_UPLOAD_SERVICE:SH_UPLOAD_ZONGHE parameters:self.paramDic withHub:YES constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *imgName = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
        NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", @"commerce", imgName];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.uploadIamge.image, 0.6) name:@"service_img[]" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(double progress) {
        [SVProgressHUD showProgress:progress];
    } success:^(NSDictionary *responseDic) {
        NSLog(@"%@",responseDic);
        if ([responseDic[@"code"] integerValue] == -1002) {
            [AlertView showYMAlertView:self.view andtitle:@"申请成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getDataArrayByRefresh" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *vcArray = self.navigationController.childViewControllers;
                UIViewController *tempVC = vcArray[2];
                [self.navigationController popToViewController:tempVC animated:YES];
            });
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"资料填写错误"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
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

        }
    } failure:^(NSError *error) {
        
    }];
}
//[self.typeBgView removeFromSuperview];
//self.typeBgView = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"入驻平台申请";
    [self setupNewAlertView];
    [self getMineMessage];
    [self.uploadBtn makeCorner: 5];
    NOTIFY_ADD(uploadData, @"uploadServiceData");
 
    if ([self.typeString isEqualToString:@"创业宝典"]) {
        self.selectTypeData =  @{@"工商注册":@"1",@"财税服务":@"5",@"知识产权":@"8",@"资质办理":@"10",@"法律服务":@"18",@"人力社保":@"21",@"场地服务":@"25",@"创业辅导":@"27",@"投融资":@"29",@"图文视频":@"33",@"视觉设计":@"36",@"市场传播":@"37",@"消防环保":@"38",@"物流快递":@"39",@"创业信息":@"41"};
        [self.selectTypeData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj integerValue]==self.typeIndex) {
                self.serviceType.text= key;
            }
        }];
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
    self.typeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.typeBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4] ];
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
    [[UIApplication sharedApplication].keyWindow addSubview:self.typeBgView];
    [self.typeBgView bk_whenTapped:^{
        [self.typeBgView removeFromSuperview];
    }];
    self.typeBgView.hidden = YES;
    [self.typeBgView addSubview:self.areaPickerView];
    self.pickSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenH-340, ScreenW, 40)];
    [self.pickSureBtn setBackgroundColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.pickSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.pickSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    __block AddServiceFormController *blockSelf = self;
    [self.pickSureBtn bk_whenTapped:^{
        blockSelf.typeBgView.hidden = YES;
    }];
    [self.typeBgView addSubview:self.pickSureBtn];
    [self.uploadIamge bk_whenTapped:^{
         [blockSelf showEditAlertView];
    }];
    self.serviceId = self.selectTypeData[self.serviceType.text];
//    [self.serviceType bk_whenTapped:^{
//
//          [[UIApplication sharedApplication].keyWindow addSubview:self.typeBgView];
//        self.typeBgView.hidden = NO;
//    }];
    [self.facePriceView bk_whenTapped:^{
        if (blockSelf.facePriceView.tag == 1) {
            blockSelf.facePriceView.tag = 2;
            [blockSelf.selImage setImage:[UIImage imageNamed:@"pro_sel_icon"]];
             blockSelf.priceTF.text = @"面议";
        }else{
            blockSelf.facePriceView.tag = 1;
            [blockSelf.selImage setImage:[UIImage imageNamed:@"pro_no_select_company"]];
            blockSelf.priceTF.text = @"";
        }
        
    }];
}

-(void)setupNewAlertView{
    __block AddServiceFormController *blockSelf = self;
    alertView = [[NSBundle mainBundle] loadNibNamed:@"NewEditAlertView" owner:self options:nil][0];
    [alertView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    alertView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    alertView.alpha = 0;
    [alertView.cancelBtn addTarget:self action:@selector(hideEditAlertView) forControlEvents:UIControlEventTouchUpInside];
    [alertView.takePhotoBtn addTarget:self action:@selector(clickToTakePhoto) forControlEvents:UIControlEventTouchUpInside];
    [alertView.photoLib addTarget:self action:@selector(clickToTakeLib) forControlEvents:UIControlEventTouchUpInside];
    [alertView bk_whenTapped:^{
        [blockSelf hideEditAlertView];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
}


-(void)savePhotoWithArray:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    [self.uploadIamge setImage:array[0]];
//    [self upavatar];
}

/**
 门店图
 */
-(void)clickToTakePhoto{
    [self hideEditAlertView];
    SHEditCommidityCameraController *cameraVC = [[SHEditCommidityCameraController alloc] initWithArray:nil maxPhotoNum:1];
    cameraVC.delegate = self;
    
    [self.navigationController pushViewController:cameraVC animated:YES];
}


/**
 门店图相册
 */
-(void)clickToTakeLib{
    [self hideEditAlertView];
    
    //相册问题
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 1;
    ac.configuration.allowSelectVideo = NO;
    ac.configuration.allowTakePhotoInLibrary = NO;
    ac.configuration.maxPreviewCount = 1;
    ac.configuration.editAfterSelectThumbnailImage = YES;
    ac.configuration.hideClipRatiosToolBar = YES;
    ac.configuration.clipRatios = @[GetClipRatio(1, 1)];
    ac.configuration.saveNewImageAfterEdit = NO;
    //    ac.configuration.clipRatios = @[1,1];
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    __block AddServiceFormController *blockself = self;
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [blockself.uploadIamge setImage:images[0]];
        //        [blockself upavatar];
        
    }];
    
    
    [ac showPhotoLibrary];
}
-(void)showEditAlertView{
     [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    [UIView animateWithDuration:0.5 animations:^{
        self->alertView.alpha = 1;
    }];
}
-(void)hideEditAlertView{
    [UIView animateWithDuration:0.5 animations:^{
        self->alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self->alertView removeFromSuperview];
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
        _areaPickerView.hidden = NO;
    }
    return  _areaPickerView;
}
@end
