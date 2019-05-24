//
//  HomeViewController.m
//  EducationMix
//
//  Created by Sam on 2019/3/12.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EduHomeViewController.h"
#import "EduHomeJobCell.h"
#import "EduHomeHeaderView.h"
#import "YYLabel.h"
#import "LPTagModel.h"
#import "HomeSectionView.h"
#import "EduNavController.h"
#import "LoginBottomView.h"
#import "EduMeViewController.h"
#import "TSInternshipDetailViewController.h"
#import "TSTechnicalRequirementsDetailViewController.h"
#import "EduStudentCell.h"
#import "SearchCommerceController.h"
#import "TSInternshipViewController.h"
#import "InstitutionViewController.h"
#import "TSTechnicalRequirementsViewController.h"
#import "TSStudentListViewController.h"
#import "ExpertTeamController.h"
#import "TSStudentDetailViewController.h"
#import "TSInstitutionTeacherViewController.h"
#import "ResultMessageController.h"
@interface EduHomeViewController ()<UITableViewDelegate,UITableViewDataSource,LPSwitchTagDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *kefuImage;
@property (weak, nonatomic) IBOutlet UIImageView *msgIcon;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;

@property (nonatomic) EduHomeHeaderView *headerView;
@property (nonatomic) HomeSectionView *sectionView;
@property (nonatomic) NSArray *workTypeArray ;
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) NSArray *posterArray;

//@property (nonatomic) LoginBottomView *loginBtnView;
@end

@implementation EduHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"产教融";
    self.workTypeArray =  @[@"全部",@"电子信息",@"装备制造", @"能源环保",@"生物技术与医药",@"新材料",@"现代农药", @"其他"];
    
    [self GetTJJob];
//    [self GetNewPost];
   
}


//-(void)getCycleImageArray{
//    __block EduHomeViewController *blockSelf = self;
//    [HTTPREQUEST_SINGLE getWithURLString:GROUND_SCROLL_IMAGE parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
//        NSString *imgURLString = responseDic[@"data"][@"square_img"];
//        NSArray *imageurlArray = [imgURLString componentsSeparatedByString:@"|"];
//        NSMutableArray * imageURLArray = [NSMutableArray arrayWithCapacity:0];
//        for (int i = 0; i <= imageurlArray.count - 1; i ++) {
//            NSString *imageString = [NSString stringWithFormat:@"%@%@",@"https://app.tianxun168.com",imageurlArray[i]];
//            [imageURLArray addObject:imageString];
//        }
//        blockSelf.posterArray = imageURLArray;
//        [blockSelf.tableView reloadData];
//    } failure:^(NSError *error) {
//
//    }];
//}
- (void)GetTJJob {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",@"",@"education",@"",@"graduation_time",@"",@"major",@"",@"sex",@"",@"student_name",@"1",@"page", nil];
//    NSString *url = @"";
    [HTTPREQUEST_SINGLE postWithURLString:SH_LIST_STUDENT_EDU parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            self.dataArray = responseDic[@"data"];
            [self GetNewPost];
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    }];
}
-(void)viewWillLayoutSubviews{
//    if (USER_SINGLE.token.length<= 0) {
//        [[UIApplication sharedApplication].keyWindow addSubview:self.loginBtnView];
//    }
    
}
-(void)GetNewPost{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"allow_publish",@"",@"commerce_id",@"",@"area",@"",@"demand_type",@"",@"domain",@"",@"enterprise_type",@"",@"technology_name",@"1",@"page", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_NEWS_POST_HOME parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            self.posterArray = responseDic[@"data"];
             self.tableView.tableHeaderView = self.headerView;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    TSStudentDetailViewController *vc = [[TSStudentDetailViewController alloc] init];
    vc.title = @"人才详情";
    vc.student_id = [dic[@"student_id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 59;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EduStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EduStudentCell"];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.stuName.text = dic[@"student_name"];
    cell.sex.text = [NSString getSexWithSexData:[NSString stringWithFormat:@"%ld",[dic[@"sex"] isKindOfClass:[NSNull class]]?3:[dic[@"sex"] integerValue]]];
    [cell.sex makeCorner:cell.sex.frame.size.height/2];
    cell.academy.text = [dic[@"academy_name"] isKindOfClass:[NSNull class] ]?@"":dic[@"academy_name"];
    cell.time.text = [dic[@"graduation_time"] isKindOfClass:[NSNull class]]?@"":dic[@"graduation_time"];
    cell.major.text = [NSString getProfessionalField:[dic[@"major"] isKindOfClass:[NSNull class]]?0:[dic[@"major"] integerValue]];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic[@"photo"] isKindOfClass:[NSNull class]]?@"":dic[@"photo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.avatarImage setImage:[UIImage imageNamed:@"studen_default_icon"]];
        }
    }];
    [cell.avatarImage makeCorner:41];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(EduHomeHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"HomeXib" owner:self options:nil][0];
//        _headerView.frame = CGRectMake(0, 0, ScreenW, 435*kScale);
        _headerView.frame = CGRectMake(0, 0, ScreenW, 455);

        _headerView.cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _headerView.postArray = self.posterArray;
//        _headerView.cycleView.imageURLStringsGroup = self.posterArray;
        _headerView.cycleView.localizationImageNamesGroup = @[[UIImage imageNamed:@"edu_home_bannar_1"],[UIImage imageNamed:@"edu_home_bannar_2"]];
        [_headerView setupTableView];
        NSArray *imageeArr = @[[UIImage imageNamed:@"edu_home_bannar_1"],[UIImage imageNamed:@"edu_home_bannar_2"]];
        _headerView.cycleView.showPageControl = YES;
        [_headerView.cycleView setAutoScrollTimeInterval:5];
        _headerView.cycleView.autoScroll = imageeArr.count >1?YES:NO;
        _headerView.cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        
        @weakify(self);

        _headerView.callBackBlock = ^(NSDictionary * _Nonnull dic) {
            @strongify(self);
            TSTechnicalRequirementsDetailViewController *vc = [[TSTechnicalRequirementsDetailViewController alloc] init];
            vc.technology_id = [dic[@"technology_id"] integerValue];
            vc.commerce_id = [dic[@"commerce_id"] integerValue];
            vc.title = @"技术需求详细";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        _headerView.headerTagCallBackBlcok = ^(NSInteger index) {
            @strongify(self);
         
            
            UIViewController *vc = nil;
            
            switch (index) {
                case 1:
                    vc = [[InstitutionViewController alloc] init];
                    
                    break;
                case 2:
                    vc = [[TSStudentListViewController alloc] init];
                    vc.title = @"人才招聘列表";
                    break;
                case 3:
                    vc = [[TSTechnicalRequirementsViewController alloc] init];

                    break;
                case 4:
                    vc = [[ExpertTeamController alloc] init];
                    

                    break;
                case 7:
                    vc = [[TSInstitutionTeacherViewController alloc] init];
                    
                    break;
                case 5:
                    vc = [[ResultMessageController alloc] init];
                    
                    break;
                default:
                    
                    break;
            }
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        };
        
    }
    return _headerView;
}
-(HomeSectionView *)sectionView{
    if (_sectionView == nil) {
        _sectionView = [[NSBundle mainBundle] loadNibNamed:@"homeview" owner:self options:nil][1];
        _sectionView.titleLabel.text = @"推荐简历";
        _sectionView.checkLabel.text = @"查看更多简历 >";
        [_sectionView.checkLabel bk_whenTapped:^{
            SearchCommerceController *searchVC = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchCommerceController"];
            [self.navigationController pushViewController:searchVC animated:YES];
        }];
        _sectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _sectionView;
}

@end
