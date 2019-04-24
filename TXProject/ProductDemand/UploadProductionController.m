//
//  UploadProductionController.m
//  TXProject
//
//  Created by Sam on 2019/3/27.
//  Copyright © 2019 sam. All rights reserved.
//

#import "UploadProductionController.h"
#import "ProductionImageCell.h"
#import "ProMsgCell.h"
#import "ProductionDetailDescCell.h"
#import "ProductionContactCell.h"
#import "ProShowTimeCell.h"
#import "ProSelectCompanyCell.h"
#import "ProTypeView.h"
#import "ProDateView.h"

#import "ProCompanyListController.h"
@interface UploadProductionController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;
@property (nonatomic) NSMutableArray *imageArray;
@property (nonatomic) ProTypeView *proTypeView;
@property (nonatomic) NSArray *protypeArray;
@property (nonatomic) NSString *proTypeIndex;
@property (nonatomic) ProDateView *proDatePickView;
@property (nonatomic) NSDictionary *companyDic;
@property (nonatomic) NSMutableDictionary *dataDic;
@end

@implementation UploadProductionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    self.protypeArray = @[ @"组件零部件",@"文化教育创意",@"酒店旅游餐饮",@"食品饮料",@"医疗保健",@"家电家居",@"冶金能源环保",@"化学化工",@"汽车工业",@"其他"];
    if (self.editDic != nil) {
        [self GetDetailData];
    }else{
        self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    [view setBackgroundColor:[UIColor colorWithRGB:0xf2f2f2]];
    self.tableView.tableFooterView = view;
    self.title = @"发布需求";
    [self.submitLabel bk_whenTapped:^{
        [self uploadData];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)GetDetailData{
    NSDictionary *param = @{@"product_id":self.editDic[@"product_id"]};
    __block UploadProductionController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_PROJECT_DETAIL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSArray *arr = responseDic[@"data"];
            blockSelf.dataDic = [NSMutableDictionary dictionaryWithDictionary:arr.firstObject];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)uploadData{
    if (self.imageArray.count <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请最少选择一张图片"];
        return;
    }
    NSDictionary *keyAlertArray = @{@"product_name":@"请填写标题",@"product_type":@"请选择产品类型",@"need_number":@"请填写需求数量",@"product_unit":@"请填写单位",@"product_description":@"请填写产品描述",@"contacts_person":@"请填写联系人",@"contacts_phone":@"请填写联系方式",@"area":@"请填写所在区域",@"address":@"请填写详细地址",@"put_on_shelves_time":@"请选择上架时间",@"put_off_shelves_time":@"请选择下架时间",@"enterprise_id":@"请选择企业"};
    __block UploadProductionController *blockSelf = self;
    [keyAlertArray enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![blockSelf.dataDic.allKeys containsObject:key]||[blockSelf.dataDic[key] isKindOfClass:[NSNull class]]) {
            [AlertView showYMAlertView:blockSelf.view andtitle:obj];
            return ;
        }
    }];
    if ([self.dataDic[@"need_number"] integerValue] == 0 ) {
        [AlertView showYMAlertView:self.view andtitle:@"需求数量最少为1"];
        return;
    }
    if ([self.dataDic[@"product_type"] integerValue] == 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请选择产品类型"];
        return;
    }
 
    [self.dataDic setObject:USER_SINGLE.default_commerce_id forKey:@"commerce_id"];
//    [self.dataDic removeObjectForKey:@"token"];
//    [self.dataDic setObject:USER_SINGLE.token forKey:@"token"];
    [HTTPREQUEST_SINGLE uploadImageArrayWithUrlStr:SH_ADD_PRODUCTION parameters:self.dataDic withHub:YES constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(NSInteger i = 0; i < self.imageArray.count; i++) {


            NSData * imageData = UIImageJPEGRepresentation([self.imageArray objectAtIndex: i], 0.5);
            // 上传的参数名

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:imageData name:@"avatar[]" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(double progress) {
        
    } success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == -1002) {
            [AlertView showYMAlertView:self.view andtitle:@"发布成功"];
            NOTIFY_POST(@"GetProductionData");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"提交失败"];
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"提交失败"];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __block UploadProductionController *blockSelf = self;
    if (indexPath.row == 0) {
        ProductionImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionImageCell"];
        cell.imageArray = [NSMutableArray arrayWithArray:self.imageArray];
        cell.uploadVC = self;
        cell.tableView = self.tableView;
        [cell setupCollection];
        cell.selectArrayCallBack = ^(NSArray * _Nonnull imageArray) {
            blockSelf.imageArray = [NSMutableArray arrayWithArray:imageArray];
            [blockSelf.tableView reloadData];
        };
        return cell;
    }else if (indexPath.row == 1){
        ProMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProMsgCell"];
        [cell.typeView bk_whenTapped:^{
            blockSelf.proTypeView.hidden = NO; 
        }];
        if ([self.dataDic.allKeys containsObject:@"product_type"]) {
            cell.proTypeLB.text = self.protypeArray[[self.dataDic[@"product_type"]integerValue]-1];
            cell.proTypeLB.textColor = [UIColor blackColor];
        }
        if ([self.dataDic.allKeys containsObject:@"product_name"]) {
            cell.titleTF.text = self.dataDic[@"product_name"];
        }
        if ([self.dataDic.allKeys containsObject:@"need_number"]) {
            cell.needNumber.text = [NSString stringWithFormat:@"%ld",[self.dataDic[@"need_number"] integerValue]];
        }
        if ([self.dataDic.allKeys containsObject:@"product_unit"]) {
            cell.unit.text = self.dataDic[@"product_unit"];
        }
        [[cell.titleTF rac_textSignal] subscribeNext:^(NSString *x) {
            [blockSelf.dataDic setObject:x forKey:@"product_name"];
        }];
        [[cell.needNumber rac_textSignal] subscribeNext:^(id x) {
            [blockSelf.dataDic setObject:x forKey:@"need_number"];
        }];
        [[cell.unit rac_textSignal]subscribeNext:^(id x) {
            [blockSelf.dataDic setObject:x forKey:@"product_unit"];
        }];
        
    
        return cell;
    }else if (indexPath.row == 2){
        ProductionDetailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionDetailDescCell"];
        if ([self.dataDic.allKeys containsObject:@"product_description"]) {
            cell.descTF.text = self.dataDic[@"product_description"];
        }
        [[cell.descTF rac_textSignal] subscribeNext:^(id x) {
            [blockSelf.dataDic setObject:x forKey:@"product_description"];
        }];
        return cell;
    }else if (indexPath.row == 3){
        ProductionContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionContactCell"];
        if ([self.dataDic.allKeys containsObject:@"contacts_person"]) {
            cell.name.text = self.dataDic[@"contacts_person"];
        }
        [[cell.name rac_textSignal] subscribeNext:^(id x) {
            [blockSelf.dataDic setObject:x forKey:@"contacts_person"];
        }];
        if ([self.dataDic.allKeys containsObject:@"contacts_phone"]) {
            cell.contact.text = self.dataDic[@"contacts_phone"];
        }
        [[cell.contact rac_textSignal] subscribeNext:^(id x) {
            [blockSelf.dataDic setObject:x forKey:@"contacts_phone"];
        }];
        if ([self.dataDic.allKeys containsObject:@"area"]) {
            cell.area.text = self.dataDic[@"area"];
        }
        [[cell.area rac_textSignal] subscribeNext:^(id x) {
            [blockSelf.dataDic setObject:x forKey:@"area"];
        }];
        if ([self.dataDic.allKeys containsObject:@"address"]) {
            cell.detailAddress.text = self.dataDic[@"address"];
        }
        
        return cell;
    }
    else if (indexPath.row == 4){
        ProShowTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProShowTimeCell"];
        [cell.startTimeView bk_whenTapped:^{
            blockSelf.proDatePickView.hidden = NO;
            blockSelf.proDatePickView.title.text = @"设置上架时间";
        }];
        [cell.endTimeView bk_whenTapped:^{
            blockSelf.proDatePickView.hidden = NO;
            blockSelf.proDatePickView.title.text = @"设置下架时间";
        }];
        if ([self.dataDic.allKeys containsObject:@"put_on_shelves_time"]) {
            cell.startTime.text = self.dataDic[@"put_on_shelves_time"];
        }
        if ([self.dataDic.allKeys containsObject:@"put_off_shelves_time"]) {
            cell.endTime.text = self.dataDic[@"put_off_shelves_time"];
        }
        
        return cell;
    }else{
        ProSelectCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProSelectCompanyCell"];
        if (USER_SINGLE.default_company_dic != nil&&self.companyDic==nil) {
            cell.companyLabel.text = USER_SINGLE.default_company_dic[@"enterprise_name"];
             [self.dataDic setObject:USER_SINGLE.default_company_dic[@"enterprise_id"] forKey:@"enterprise_id"];
        }else{
             cell.companyLabel.text = self.companyDic[@"enterprise_name"];
        }
        [cell.companyView bk_whenTapped:^{
            ProCompanyListController *vc = [[UIStoryboard storyboardWithName:@"Production" bundle:nil] instantiateViewControllerWithIdentifier:@"ProCompanyListController"];
            vc.changeDefault = NO;
            [blockSelf.navigationController setNavigationBarHidden:NO animated:NO];
            [blockSelf.navigationController pushViewController:vc animated:YES];
            __block UploadProductionController *blockblockSelf = self;
            vc.selectNSDictionaryCallBack = ^(NSDictionary * _Nonnull dic) {
                NSMutableDictionary *tableDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSNull class]]) {
                        [tableDic setObject:@"" forKey:key];
                    }else{
                        [tableDic setObject:obj forKey:key];
                    }
                }];
                blockblockSelf.companyDic = tableDic;
//                USER_SINGLE.default_company_dic = tableDic;
                [blockblockSelf.dataDic setObject:tableDic[@"enterprise_id"] forKey:@"enterprise_id"];
                [blockblockSelf.tableView reloadData];
            };
        }];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.imageArray.count == 0) {
            return 189;
        }else{
            return 189  + self.imageArray.count/3 * 115;
        }
        
    }else if (indexPath.row == 1){
        return 172;
    }else if (indexPath.row == 2){
        return 126;
    }else if (indexPath.row == 3){
        return 224;
    }else if (indexPath.row == 4){
        return 120;
    }else{
        return 52;
    }
}

-(ProTypeView *)proTypeView{
    if (_proTypeView == nil) {
        _proTypeView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][3];
        _proTypeView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 68);
        _proTypeView.dataArray = self.protypeArray;
        [_proTypeView setupCollectionView];
        _proTypeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        __block UploadProductionController *blockSelf = self;
        _proTypeView.selectStringCallBack = ^(NSString * _Nonnull str) {
            blockSelf.proTypeIndex = [NSString stringWithFormat:@"%lu",[blockSelf.proTypeView.dataArray indexOfObject:str]+1];
            [blockSelf.dataDic setObject:blockSelf.proTypeIndex forKey:@"product_type"];
            blockSelf.proTypeView.hidden =YES;
            [blockSelf.tableView reloadData];
        };
        [self.view addSubview:_proTypeView];
    }
    return _proTypeView;
}
-(ProDateView *)proDatePickView{
    if (_proDatePickView == nil) {
        _proDatePickView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][4];
        _proDatePickView.frame = CGRectMake(0, 0 , ScreenW, ScreenH-68);
        _proDatePickView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.view addSubview:_proDatePickView];
        [_proDatePickView setupDatePicker];
        __block UploadProductionController *blockSelf = self;
        _proDatePickView.selectStringCallBack = ^(NSString * _Nonnull str) {
            if ([blockSelf.proDatePickView.title.text isEqualToString:@"设置上架时间"]) {
                [blockSelf.dataDic setObject:str forKey:@"put_on_shelves_time"];
            }else{
                [blockSelf.dataDic setObject:str forKey:@"put_off_shelves_time"];
            }
            blockSelf.proDatePickView.hidden = YES;
            [blockSelf.tableView reloadData];
        };
     
        [_proDatePickView.closeView bk_whenTapped:^{
            blockSelf.proDatePickView.hidden = YES;
        }];
    }
    return _proDatePickView;
}
@end
