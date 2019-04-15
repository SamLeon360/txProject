//
//  StudentJobDetailController.m
//  TXProject
//
//  Created by Sam on 2019/3/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import "StudentJobDetailController.h"
#import "StuJobTitleCell.h"
#import "StuJobOneCell.h"
#import "StuJobTwoCell.h"
#import "StuJobThreeCell.h"
#import "StuJobFourCell.h"
#import "StuJobBtnCell.h"
#import "StuJobOtherStuCell.h"
#import "otherJobDetailCell.h"
#import "CommentsController.h"

@interface StudentJobDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSDictionary *dataDic;
@property (nonatomic) NSArray *personArray;
@property (nonatomic) NSArray *educationArray;
@property (nonatomic) NSArray *otherJobArray;
@property (nonatomic) CGFloat workaddHeight;
@property (nonatomic) CGFloat jobContentHeight;

@end

@implementation StudentJobDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.educationArray =  @[@"全部", @"博士", @"硕士", @"本科", @"大专", @"高职", @"中职", @"不限"];
    self.title = @"人才需求信息";
    [self getNetData];
   
}
-(void)setupClickAction{
    
}
-(void)getNetData{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectData[@"commerce_id"],@"commerce_id",self.selectData[@"talent_id"],@"talent_id",@"0",@"_search_type",@"1",@"page", nil];
    __block StudentJobDetailController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_JOB_STU_DETAIL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSArray *arr = responseDic[@"data"];
            blockSelf.dataDic = arr.firstObject;

            [blockSelf.tableView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
    NSDictionary *param1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",@"1",@"allow_publish",@"0",@"commerce_id",@"",@"education",self.selectData[@"enterprise_id"],@"enterprise_id",@"",@"job_name",@"",@"job_type",@"1",@"page",@"1",@"receive_fresh_graduate",@"",@"work_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_OTHER_JOB parameters:param1 withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            blockSelf.otherJobArray = responseDic[@"data"];
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count + self.otherJobArray.count + 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.otherJobArray.count > 0) {
        if (indexPath.row <= 4) {
            return  [self fineCellForIndex:indexPath];
        }else if (indexPath.row > 4 && indexPath.row < 5 + self.otherJobArray.count){
            otherJobDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"otherJobDetailCell"];
            NSDictionary *dic = self.otherJobArray[indexPath.row - 5];
            cell.jobName.text = dic[@"job_name"];
            cell.moneyLabel.text = [NSString stringWithFormat:@"%@-%@元/月",self.dataDic[@"salary_min"],self.dataDic[@"salary_max"]];
            cell.welfare.text = [self.dataDic[@"welfare"] stringByReplacingOccurrencesOfString:@"|" withString:@" "];
            cell.areaLabel.text = [self.dataDic[@"area"] stringByReplacingOccurrencesOfString:@"|" withString:@""];
            return cell;
        }else if (indexPath.row == 5 + self.otherJobArray.count){
            StuJobBtnCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuJobBtnCell"];
            [cell.hotLineLabel makeCorner:5];
            [cell.msgLabel makeCorner:5];
            [cell.msgLabel bk_whenTapped:^{
                CommentsController *vc = [[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"CommentsController"];
                vc.dataDic = self.dataDic;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [cell.hotLineLabel bk_whenTapped:^{
                
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.dataDic[@"contacts_phone"]];
                UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            return cell;
        }
        else{
            return  [self otherStudentCell:indexPath];
        }
    }else{
        if (indexPath.row <= 4) {
            return  [self fineCellForIndex:indexPath];
        }else if (indexPath.row == 5){
            StuJobBtnCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuJobBtnCell"];
            [cell.hotLineLabel makeCorner:5];
            [cell.msgLabel makeCorner:5];
            [cell.msgLabel bk_whenTapped:^{
                CommentsController *vc = [[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"CommentsController"];
                vc.dataDic = self.dataDic;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [cell.hotLineLabel bk_whenTapped:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.dataDic[@"contacts_phone"]];
                UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
           
            }];
            return cell;
        }
        else{
            return  [self otherStudentCell:indexPath];
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else if (indexPath.row == 1){
        return self.workaddHeight + 180 - 16;
    }else if (indexPath.row == 2){
        return self.jobContentHeight - 16 + 80;
    }else if (indexPath.row == 3){
        return 100;
    }else if (indexPath.row == 4){
        return 45;
    }
    if (self.otherJobArray.count > 0) {
        if (indexPath.row >= 5 && indexPath.row < 5 + self.otherJobArray.count) {
            return 90;
        }else if (indexPath.row == 5 + self.otherJobArray.count){
            return 130;
        }else{
            return 80;
        }
    }else{
        if (indexPath.row == 5) {
            return 130;
        }else{
            return 80;
        }
    }
}
-(UITableViewCell *)otherStudentCell:(NSIndexPath *)indexPath{
    StuJobOtherStuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuJobOtherStuCell"];
    NSDictionary *dic = self.personArray[indexPath.row];
    cell.name.text = dic[@"student_name"];
    int birthdayYear = [[dic[@"birthday"] componentsSeparatedByString:@"|"].firstObject intValue];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    int thisYear = [ [dateformatter stringFromDate:senddate] intValue];
    cell.msgLabel.text = [NSString stringWithFormat:@"%@,%@岁",[dic[@"sex"] integerValue] == 1?@"男":@"女",[NSString stringWithFormat:@"%d",thisYear-birthdayYear]];
    cell.jobLabel.text = dic[@"major"];
    cell.areaLabel.text = [dic[@"region"] stringByReplacingOccurrencesOfString:@"|" withString:@""];
    [cell bk_whenTapped:^{
            
    }];
    return cell;
}
-(UITableViewCell *)fineCellForIndex:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            StuJobTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuJobTitleCell"];
            cell.title.text = self.dataDic[@"job_name"];
            return cell;
        }break;
        case 1:{
            StuJobOneCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuJobOneCell"];
            cell.moneyLabel.text = [NSString stringWithFormat:@"%@-%@元/月",self.dataDic[@"salary_min"],self.dataDic[@"salary_max"]];
            NSString *educationString ;
            if ([self.dataDic[@"education"] integerValue] == 0||[self.dataDic[@"education"] integerValue] == 7) {
                educationString = @"学历不限";
            }else{
                educationString = [NSString stringWithFormat:@"%@以上",self.educationArray[[self.dataDic[@"education"] integerValue]]];
            }
            NSString *requirOne = [self.dataDic[@"receive_fresh_graduate"] integerValue] == 1?@"接受应届生":@"不接受应届生";
            NSString *requirTwo = [self.dataDic[@"age_limit"] isKindOfClass:[NSNull class]]?@"":[NSString stringWithFormat:@"%@岁",self.dataDic[@"age_limit"]];
            cell.requirementLabel.text = [NSString stringWithFormat:@"%@,%@,%@",educationString,requirOne,requirTwo];
            cell.welfareLabel.text = [self.dataDic[@"welfare"] stringByReplacingOccurrencesOfString:@"|" withString:@" "];
            cell.addressLabel.text = self.dataDic[@"work_address"];
            self.workaddHeight = [CustomFountion getHeightLineWithString:self.dataDic[@"work_address"] withWidth:cell.addressLabel.frame.size.width withFont:[UIFont systemFontOfSize:13]];
            return cell;
        }break;
        case 2:{
            StuJobTwoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuJobTwoCell"];
            cell.jobContentLabel.text = self.dataDic[@"job_description"];
            self.jobContentHeight = [CustomFountion getHeightLineWithString:self.dataDic[@"job_description"] withWidth:cell.jobContentLabel.frame.size.width withFont:[UIFont systemFontOfSize:13]];
            return cell;
        }break;
        case 3:{
            StuJobThreeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuJobThreeCell"];
            cell.companyName.text = self.dataDic[@"enterprise_name"];
            cell.phoneNumber.text = self.dataDic[@"contacts_phone"];
            [cell.phoneView bk_whenTapped:^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.dataDic[@"contacts_phone"]];
                UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            return cell;
        }break;
        case 4:{
            StuJobFourCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuJobFourCell"];
            
            return cell;
        }break;
   
        default:
            return nil;
            break;
    }
}
@end
