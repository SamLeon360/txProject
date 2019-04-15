//
//  ProductionPostAndEditController.m
//  TXProject
//
//  Created by Sam on 2019/3/28.
//  Copyright © 2019 sam. All rights reserved.
//

#import "JobPostAndEditController.h"
#import "JobUploadNormalCell.h"
#import "JobDescCell.h"
#import "JobSureCell.h"
#import "JobSelectView.h"
#import "ProDateView.h"
#import "GetAreaView.h"
@interface JobPostAndEditController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *cellTitleArray;
@property (nonatomic) NSArray *placeholderArray;
@property (nonatomic) NSArray *keyArray;
@property (nonatomic) JobSelectView *jobTimeView;
@property (nonatomic) JobSelectView *workerTypeView;
@property (nonatomic) JobSelectView *welfareView;
@property (nonatomic) JobSelectView *companySelectView;
@property (nonatomic) JobSelectView *jobTypeView;
@property (nonatomic) JobSelectView *studentTypeView;
@property (nonatomic) ProDateView *proDatePickView;
@property (nonatomic) NSMutableDictionary *dataDic;
@property (nonatomic) NSArray *educationArray;
@property (nonatomic) NSArray *jobTypeArray;
@property (nonatomic) NSArray *welfareArray;
@property (nonatomic) GetAreaView *getAreaView;
@property (nonatomic) NSString *selectAreaString;
@end

@implementation JobPostAndEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.getAreaView.hidden = YES;
    if (self.editData == nil) {
        self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [self.dataDic setObject:USER_SINGLE.default_commerce_id forKey:@"commerce_id"];
        
    }else{
        [self GetDetailData];
    }
    self.title = self.editData == nil ? @"添加人才需求":@"编辑人才需求";
    self.educationArray = @[@"博士",@"硕士",@"本科",@"大专",@"高职",@"中职",@"不限"];
    self.welfareArray = @[@"包吃",@"饭补",@"话补",@"房补",@"年底双薪",@"周末双休",@"加班补助",@"交通补助"];
    self.jobTypeArray = @[@"IT通信电子",@"财务金融",@"房产/建筑建设/物业",@"服务业",@"管理/人力资源/行政",@"广告/市场/媒体/艺术",@"汽车/工程机械",@"消费品生产/物流",@"销售/客户/导购",@"医药/化工/能源/环保",@"资讯/法律/教育/翻译",@"农牧业",@"其他"];
    self.cellTitleArray = @[@[@"公司选择："],@[@"岗位名称：",@"最低月薪：",@"最高月薪：",@"学历要求：",@"工作年限：",@"年龄要求：",@"接受应届生：",@"工作方式：",@"工作福利：",@"工作地址：",@"详细地址：",@"联系方式：",@"职位类型：",@""],@[@"上架时间：",@"下架时间：",@""]];
    self.placeholderArray = @[@[@""],@[@"请输入岗位名称",@"输入整数数字 如:6000",@"输入整数数字 如:4000",@"",@"输入整数数字 如:1",@"请用文字描述 如:18周岁以上",@"",@"",@"",@"",@"请输入详细地址",@"填写手机或固话",@"",@""],@[@"",@"",@""]];
    self.keyArray = @[@[@"enterprise_name"],@[@"job_name",@"salary_min",@"salary_max",@"education",@"work_life",@"age_limit",@"receive_fresh_graduate",@"work_type",@"welfare",@"area",@"work_address",@"contacts_phone",@"job_type",@"job_description"],@[@"start_time",@"end_time"]];
    
    [self.tableView reloadData];
    self.welfareView.hidden = YES;
    self.jobTimeView.hidden = YES;
    self.workerTypeView.hidden = YES;
    self.companySelectView.hidden = YES;
    self.jobTypeView.hidden = YES;
    self.studentTypeView.hidden= YES;
    self.proDatePickView.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super  viewWillDisappear:animated];
    [self.welfareView removeFromSuperview];
    [self.jobTimeView removeFromSuperview];
    [self.workerTypeView removeFromSuperview];
    [self.companySelectView removeFromSuperview];
    [self.jobTypeView removeFromSuperview];
    [self.studentTypeView removeFromSuperview];
    [self.proDatePickView removeFromSuperview];
    self.companySelectView = nil;
}
-(void)GetDetailData{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.editData[@"talent_id"],@"talent_id",@"0",@"_search_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_DETAIL_TALENT parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSArray *arr = responseDic[@"data"];
            
            self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
            NSDictionary *dic = arr.firstObject;
            [self.dataDic setDictionary:dic];
            [self.dataDic setObject:USER_SINGLE.default_commerce_id forKey:@"commerce_id"];
            
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)uploadParam{
    [HTTPREQUEST_SINGLE postWithURLString:SH_ADD_TALENT parameters:self.dataDic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == -1002) {
            [AlertView showYMAlertView:self.view andtitle:@"添加成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetJobListData" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"请填写完整信息"];
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.cellTitleArray[section];
    return arr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc] init];
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        view.backgroundColor = [UIColor colorWithRGB:0xf3f3f3];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 50)];
        if (section == 1){
            label.text = @"设置人才需求基本信息";
        }else{
            label.text = @"设置人才需求展示时间";
        }
        [view addSubview:label];
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (indexPath.section == 1&&indexPath.row == 13) {
        JobDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobDescCell"];
        cell.contentTF.layer.borderWidth = 1;
        cell.contentTF.layer.borderColor = [UIColor colorWithRGB:0xf2f2f2].CGColor;

        if ([self.dataDic.allKeys containsObject:@"job_description"]) {
            cell.contentTF.text = self.dataDic[@"job_description"];
        }else{
            if (cell.contentTF.text.length > 0 ) {
                cell.contentTF.text = @"";
            }
            [[cell.contentTF rac_textSignal] subscribeNext:^(id x) {
                [self.dataDic setObject:cell.contentTF.text forKey:@"job_description"];
            }];
        }
        return cell;
    }else if (indexPath.section == 2&&indexPath.row == 2){
        JobSureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobSureCell"];
        [cell.addLabel setText: self.editData==nil?@"添加":@"编辑"];
        [cell.addLabel bk_whenTapped:^{
            [self uploadParam];
        }];
        [cell.resetLabel bk_whenTapped:^{
            self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [self.dataDic setObject:USER_SINGLE.default_commerce_id forKey:@"commerce_id"];
            [self.tableView reloadData];
        }];
        return cell;
    }else{
        JobUploadNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobUploadNormalCell"];
        NSArray *titleArr = self.cellTitleArray[indexPath.section];
        cell.title.text = titleArr[indexPath.row];
        NSArray *placeArray = self.placeholderArray[indexPath.section];
        NSString *placeholder = placeArray[indexPath.row];
        cell.contentTF.hidden = placeholder.length ==0 ? YES:NO;
        cell.contentLabel.hidden = placeholder.length == 0 ? NO:YES;
        cell.contentTF.placeholder = placeholder;
        NSArray *cellkeyArray = self.keyArray[indexPath.section];
        if (cell.contentTF.hidden) {
            if ([self.dataDic.allKeys containsObject:cellkeyArray[indexPath.row]]) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[cellkeyArray[indexPath.row]]];
            }
        }else{
            
            if ([self.dataDic.allKeys containsObject:cellkeyArray[indexPath.row]]) {
                cell.contentTF.text = [NSString stringWithFormat:@"%@",self.dataDic[cellkeyArray[indexPath.row]]];
            }else{
                if (cell.contentTF.text.length > 0 ) {
                    cell.contentTF.text = @"";
                }
                __block JobPostAndEditController *blockSelf = self;
                [[cell.contentTF rac_textSignal] subscribeNext:^(id x) {
                    NSIndexPath *indexP = [blockSelf.tableView   indexPathForCell:cell];
                    [blockSelf.dataDic setObject:cell.contentTF.text forKey:cellkeyArray[indexP.row]];
                }];
            }
        }
        [self setupCellLabelClickAction:cell andIndex:indexPath];
        [self setupData:cell andIndex:indexPath];
        return cell;
    }
}
-(void)setupData:(JobUploadNormalCell *)cell andIndex:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        if ([self.dataDic.allKeys containsObject:@"enterprise_id"]) {
            for (NSDictionary *dic in self.companyArray) {
                if ([dic[@"enterprise_id"] integerValue]==[self.dataDic[@"enterprise_id"] integerValue]) {
                    cell.contentLabel.text = dic[@"enterprise_name"];
                }
            }
        }else{
            cell.contentLabel.text = @"";
        }
    }else if (indexPath.section == 1 && indexPath.row == 3){
        if ([self.dataDic.allKeys containsObject:@"education"]) {
             cell.contentLabel.text = self.educationArray[[self.dataDic[@"education"] integerValue]-1];
        }else{
            cell.contentLabel.text = @"";
        }
    }else if (indexPath.section == 1 && indexPath.row == 6){
        if ([self.dataDic.allKeys containsObject:@"receive_fresh_graduate"]) {
            cell.contentLabel.text = [self.dataDic[@"receive_fresh_graduate"] integerValue]==1?@"是":@"否";
        }else{
            cell.contentLabel.text = @"";
        }
    }else if (indexPath.section == 1 && indexPath.row == 7){
       
        if ([self.dataDic.allKeys containsObject:@"work_type"]) {
            cell.contentLabel.text = [self.dataDic[@"work_type"] integerValue] == 1?@"全职":@"兼职";
        }else{
            cell.contentLabel.text = @"";
        }
    }else if (indexPath.section == 1 && indexPath.row == 8){
          if ([self.dataDic.allKeys containsObject:@"welfare"]) {
            cell.contentLabel.text = self.dataDic[@"welfare"];
          }else{
              cell.contentLabel.text = @"";
          }
        
    }else if (indexPath.section == 1 && indexPath.row == 12){
        if ([self.dataDic.allKeys containsObject:@"job_type"]) {
            cell.contentLabel.text = self.jobTypeArray[[self.dataDic[@"job_type"] integerValue] - 1];
        }else{
            cell.contentLabel.text = @"";
        }
    }else if (indexPath.section == 2 && indexPath.row == 0 ){
        if ([self.dataDic.allKeys containsObject:@"start_time"]) {
            self.proDatePickView.title.text = @"设置上架时间";
            cell.contentLabel.text = self.dataDic[@"start_time"];
        }else{
            cell.contentLabel.text = @"";
        }
    }else if (indexPath.section == 2 && indexPath.row == 1){
        if ([self.dataDic.allKeys containsObject:@"end_time"]) {
         self.proDatePickView.title.text = @"设置下架时间";
         cell.contentLabel.text = self.dataDic[@"end_time"];
        }else{
            cell.contentLabel.text = @"";
        }
    }else if (indexPath.section == 1 && indexPath.row == 9){
        if ([self.dataDic.allKeys containsObject:@"area"]) {
            cell.contentLabel.text = self.dataDic[@"area"];
        }else{
            cell.contentLabel.text = @"";
        }
    }
    else{
        NSArray *cellkeyArray = self.keyArray[indexPath.section];
       
        if ((indexPath.row == 1 && indexPath.section == 1)||(indexPath.row == 2 && indexPath.section == 1)) {
             cell.contentTF.keyboardType = UIKeyboardTypePhonePad;
            [self.dataDic setObject:[NSString stringWithFormat:@"%ld",(long)[cell.contentTF.text integerValue]] forKey:cellkeyArray[indexPath.row]];
        }else{
             cell.contentTF.keyboardType = UIKeyboardTypeDefault;
             [self.dataDic setObject:cell.contentTF.text forKey:cellkeyArray[indexPath.row]];
        }
    }
}
-(void)setupCellLabelClickAction:(JobUploadNormalCell *)cell andIndex:(NSIndexPath *)indexPath{
    [cell bk_removeAllBlockObservers];
    __block JobPostAndEditController *blockSelf = self;
    [cell bk_whenTapped:^{
        NSIndexPath *indexP = [blockSelf.tableView indexPathForCell:cell];
    self.welfareView.hidden = YES;
    self.jobTimeView.hidden = YES;
    self.workerTypeView.hidden = YES;
    self.companySelectView.hidden = YES;
    self.jobTypeView.hidden = YES;
    self.studentTypeView.hidden= YES;
    self.proDatePickView.hidden = YES;
    if (indexP.section == 0 && indexP.row == 0) {
        self.companySelectView.hidden = NO;
    }else if (indexP.section == 1 && indexP.row == 3){
        self.studentTypeView.hidden = NO;
    }else if (indexP.section == 1 && indexP.row == 6){
        self.workerTypeView.hidden = NO;//兼职全职
    }else if (indexP.section == 1 && indexP.row == 7){
        self.jobTimeView.hidden = NO;//是否
    }else if (indexP.section == 1 && indexP.row == 8){
        self.welfareView.hidden = NO;//福利
    }else if (indexP.section == 1 && indexP.row == 12){
        self.jobTypeView.hidden = NO;//职位类型
    }else if (indexP.section == 2 && indexP.row == 0 ){
        self.proDatePickView.title.text = @"设置上架时间";
        self.proDatePickView.hidden = NO;
    }else if (indexP.section == 2 && indexP.row == 1){
        self.proDatePickView.title.text = @"设置下架时间";
        self.proDatePickView.hidden = NO;
    }else if (indexP.section == 1 && indexP.row == 9){
        self.getAreaView.hidden = NO;
    }
    else{
        [cell.contentTF becomeFirstResponder];
    }
      
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 2) {
        return 60;
    }else if (indexPath.section == 1&&indexPath.row == 13){
        return 125;
    }else{
        return 50;
    }
}
-(JobSelectView *)jobTimeView{
    if (_jobTimeView == nil) {
        _jobTimeView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][8];
        _jobTimeView.frame = CGRectMake(0, ScreenH - 300, ScreenW, 300);
        _jobTimeView.dataArray = @[@"全职",@"兼职"];
        [self.view addSubview:_jobTimeView];
        _jobTimeView.muSelect = NO;
        [_jobTimeView setupTableView];
        __block JobPostAndEditController *blockSelf = self;
        [_jobTimeView.cancelLabel bk_whenTapped:^{
            blockSelf.jobTimeView.hidden = YES;
        }];
        _jobTimeView.selectStringCallBack = ^(NSString * _Nonnull str) {
            [blockSelf.dataDic setObject:str forKey:@"work_type"];
            [blockSelf.tableView reloadData];
        };
    }
    return _jobTimeView;
}
-(JobSelectView *)workerTypeView{
    if (_workerTypeView == nil) {
        _workerTypeView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][8];
        _workerTypeView.frame =CGRectMake(0, ScreenH - 300, ScreenW, 300);
        _workerTypeView.dataArray = @[@"是",@"否"];
        [self.view addSubview:_workerTypeView];
        _workerTypeView.muSelect = NO;
        [_workerTypeView setupTableView];
        __block JobPostAndEditController *blockSelf = self;
        [_workerTypeView.cancelLabel bk_whenTapped:^{
            blockSelf.workerTypeView.hidden = YES;
        }];
        _workerTypeView.selectStringCallBack = ^(NSString * _Nonnull str) {
            [blockSelf.dataDic setObject:str forKey:@"receive_fresh_graduate"];
            [blockSelf.tableView reloadData];
        };
    }
    return _workerTypeView;
}
-(JobSelectView *)welfareView{
    if (_welfareView == nil) {
        _welfareView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][8];
        _welfareView.frame =CGRectMake(0, ScreenH - 600, ScreenW, 600);
        _welfareView.dataArray = self.welfareArray;
        [self.view addSubview:_welfareView];
        _welfareView.muSelect = YES;
        [_welfareView setupTableView];
        __block JobPostAndEditController *blockSelf = self;
        [_welfareView.cancelLabel bk_whenTapped:^{
            blockSelf.welfareView.hidden = YES;
        }];
        _welfareView.selectStringCallBack = ^(NSString * _Nonnull str) {
            NSArray *welArr = [str componentsSeparatedByString:@"|"];
            
            NSString *welString = @"";
            for (int i = 0 ; i<welArr.count ; i++) {
                if (i == 0) {
                    welString = blockSelf.welfareArray[[welArr[0] integerValue]];
                }else{
                    welString = [welString stringByAppendingString:[NSString stringWithFormat:@"|%@",blockSelf.welfareArray[[welArr[i] integerValue]]]];
                }
            }
            [blockSelf.dataDic setObject:welString forKey:@"welfare"];
            [blockSelf.tableView reloadData];
        };
    }
    return _welfareView;
}
-(JobSelectView *)companySelectView{
    if (_companySelectView == nil) {
        _companySelectView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][8];
        _companySelectView.frame =CGRectMake(0, ScreenH - 600, ScreenW, 600);
        _companySelectView.dataArray = self.companyArray;
        [self.view addSubview:_companySelectView];
        _companySelectView.muSelect = NO;
        [_companySelectView setupTableView];
        __block JobPostAndEditController *blockSelf = self;
        [_companySelectView.cancelLabel bk_whenTapped:^{
            self.companySelectView.hidden = YES;
        }];
        _companySelectView.selectStringCallBack = ^(NSString * _Nonnull str) {
        
            [blockSelf.dataDic setObject:str forKey:@"enterprise_id"];
            
            [blockSelf.tableView reloadData];
        };
    }
    return _companySelectView;
}
-(JobSelectView *)jobTypeView{
    if (_jobTypeView == nil) {
        _jobTypeView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][8];
        _jobTypeView.frame =CGRectMake(0, ScreenH - 368, ScreenW, 300);
        _jobTypeView.dataArray = self.jobTypeArray;
        [self.view addSubview:_jobTypeView];
        _jobTypeView.muSelect = NO;
        [_jobTypeView setupTableView];
        __block JobPostAndEditController *blockSelf = self;
        [_jobTypeView.cancelLabel bk_whenTapped:^{
            blockSelf.jobTypeView.hidden = YES;
        }];
        _jobTypeView.selectStringCallBack = ^(NSString * _Nonnull str) {
            [blockSelf.dataDic setObject:str forKey:@"job_type"];
            [blockSelf.tableView reloadData];
        };
    }
    return _jobTypeView;
}
-(JobSelectView *)studentTypeView{
    if (_studentTypeView == nil) {
        _studentTypeView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][8];
        _studentTypeView.frame =CGRectMake(0, ScreenH - 500, ScreenW, 500);
        _studentTypeView.dataArray = self.educationArray;
        [self.view addSubview:_studentTypeView];
        _studentTypeView.muSelect = NO;
        [_studentTypeView setupTableView];
        __block JobPostAndEditController *blockSelf = self;
        [_studentTypeView.cancelLabel bk_whenTapped:^{
            self.studentTypeView.hidden = YES;
        }];
        _studentTypeView.selectStringCallBack = ^(NSString * _Nonnull str) {
            [blockSelf.dataDic setObject:str forKey:@"education"];
            [blockSelf.tableView reloadData];
        };
    }
     return _studentTypeView;
}
-(ProDateView *)proDatePickView{
    if (_proDatePickView == nil) {
        _proDatePickView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][4];
        _proDatePickView.frame = CGRectMake(0, 0 , ScreenW, ScreenH-68);
        _proDatePickView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.view addSubview:_proDatePickView];
        [_proDatePickView setupDatePicker];
        __block JobPostAndEditController *blockSelf = self;
        _proDatePickView.selectStringCallBack = ^(NSString * _Nonnull str) {
            if ([blockSelf.proDatePickView.title.text isEqualToString:@"设置上架时间"]) {
                [blockSelf.dataDic setObject:str forKey:@"start_time"];
            }else{
                [blockSelf.dataDic setObject:str forKey:@"end_time"];
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

-(GetAreaView *)getAreaView{
    if (_getAreaView == nil) {
        __block JobPostAndEditController *blockSelf = self;
        _getAreaView = [[NSBundle mainBundle] loadNibNamed:@"Area" owner:self options:nil][0];
        _getAreaView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        [self.view addSubview:_getAreaView];
        _getAreaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_getAreaView setupTableView];
        [_getAreaView.sureBtn bk_whenTapped:^{
            blockSelf.selectAreaString = [NSString stringWithFormat:@"%@省|%@市",blockSelf.getAreaView.selectProvince,blockSelf.getAreaView.selecCity];
            [blockSelf.dataDic setObject:blockSelf.selectAreaString forKey:@"area"];
            blockSelf.getAreaView.hidden = YES;
            [blockSelf.tableView reloadData];
        }];
        [_getAreaView.clearBtn bk_whenTapped:^{
            blockSelf.selectAreaString = @"";
            blockSelf.getAreaView.selecCity = @"";
            blockSelf.getAreaView.selectProvince = @"";
            [blockSelf.getAreaView.provinceTable reloadData];
            [blockSelf.getAreaView.cityTable reloadData];
            blockSelf.getAreaView.hidden = YES;
            [blockSelf.tableView reloadData];
        }];
    }
    return _getAreaView;
}
@end
