//
//  PersonDetailController.m
//  TXProject
//
//  Created by Sam on 2019/3/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import "PersonDetailController.h"
#import "PersonHeaderCell.h"
#import "PersonThreeMsgCell.h"
#import "PersonOneMsgCell.h"
#import "PersonThreeMsgWithoutCell.h"
#import "StuJobBtnCell.h"
#import "PersonCerImageCell.h"
#import "CommentsController.h"
@interface PersonDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSDictionary *netDataDic;
@property (nonatomic) NSArray *tableDataArray;
@property (nonatomic) NSArray *titleArray;

@end

@implementation PersonDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableDataArray = [NSArray arrayWithObjects:self.netDataDic,@{@"期待职位":@"expect_jobs",@"期待薪资":@"expect_salary",@"就业区域":@"region"},@{@"获奖学金":@"scholarship",@"活动奖项":@"rewards",@"校内职务":@"campus_jobtitle"}, @{@"公司名称":@"internship_company",@"实习职位":@"internship_positions",@"实习时间":@"internship_time"},@{@"实习单位评价":@"internship_evaluation"},@{@"自我评价":@"self_evaluation"},@{@"专业技能":@"major_skill"},@{@"获得证书":@""},@{@"语言能力":@"language_skills",@"个人籍贯":@"native_place",@"联系电话":@"phone"},nil];
    self.titleArray = @[@"",@"求职意向",@"在校情况",@"实习工作经验",@"实习单位评价",@"自我评价",@"专业技能",@"获得证书"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PersonHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonHeaderCell"];
        [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,self.netDataDic[@"photo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [cell.avatarImage setImage:[UIImage imageNamed:@"student_default_avatar"]];
            }
        }];
        cell.name.text = self.netDataDic[@"student_name"];
        int birthdayYear = [[self.netDataDic[@"birthday"] componentsSeparatedByString:@"|"].firstObject intValue];
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy"];
        int thisYear = [ [dateformatter stringFromDate:senddate] intValue];
        cell.msgLabel.text = [NSString stringWithFormat:@"%@,%@岁",[self.netDataDic[@"sex"] integerValue] == 1?@"男":@"女",[NSString stringWithFormat:@"%d",thisYear-birthdayYear]];
        cell.school.text = self.netDataDic[@"academy_name"];
        cell.major.text = self.netDataDic[@"major"];
        return cell;
    }else if (indexPath.row >0 && indexPath.row <= 3){
        PersonThreeMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonThreeMsgCell"];
        NSDictionary *dic = self.tableDataArray[indexPath.row];
        cell.title.text = self.titleArray[indexPath.row];
        cell.oneTitle.text = dic.allKeys[0];
        cell.twoTitle.text = dic.allKeys[1];
        cell.threeTitle.text = dic.allKeys[2];
        cell.oneContent.text = self.netDataDic[dic[cell.oneTitle.text]];
        cell.twoContent.text = self.netDataDic[dic[cell.twoTitle.text]];
        cell.threeContent.text = self.netDataDic[dic[cell.threeTitle.text]];
        return cell;
    }else if (indexPath.row >3 && indexPath.row <= 6){
        PersonOneMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonOneMsgCell"];
        NSDictionary *dic = self.tableDataArray[indexPath.row];
        cell.title.text = dic.allKeys.firstObject;
        cell.content.text = dic.allValues.firstObject;
        return cell;
    }else if (indexPath.row == 7){
        PersonCerImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCerImageCell"];
        [cell.cerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL, [self.netDataDic[@"certificate"] isKindOfClass:[NSNull class]]?@"":self.netDataDic[@"certificate"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           
        }];
        return cell;
    }else if(indexPath.row == 8){
        PersonThreeMsgWithoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonThreeMsgWithoutCell"];
        cell.oneContent.text = self.netDataDic[@"language_skills"];
        cell.twoContent.text = self.netDataDic[@""];
        cell.threeContent.text = self.netDataDic[@"phone"];
        return cell;
    }else{
        StuJobBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StuJobBtnCell"];
        [cell.msgLabel bk_whenTapped:^{
            CommentsController *vc = [[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"CommentsController"];
            vc.dataDic = self.netDataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 126;
    }else if (indexPath.row > 0 && indexPath.row <= 3){
        return 177;
    }else if (indexPath.row>3 && indexPath.row <= 6){
        NSDictionary *dic = self.tableDataArray[indexPath.row];
        PersonOneMsgCell *cell =(PersonOneMsgCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        return [CustomFountion getHeightLineWithString:self.netDataDic[dic[cell.title.text]] withWidth:ScreenW-35 withFont:[UIFont systemFontOfSize:14]];
    }else if (indexPath.row == 7){
        return 120;
    }
    else if(indexPath.row == 8){
        return 140;
    }else{
        return 70;
    }
}


@end
