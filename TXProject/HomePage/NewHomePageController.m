//
//  NewHomePageController.m
//  TXProject
//
//  Created by Sam on 2019/2/12.
//  Copyright © 2019 sam. All rights reserved.
//

#import "NewHomePageController.h"
#import "HomeSectionView.h"
#import "PosterCell.h"
#import "EightBlockCell.h"
#import "TwoBlockCell.h"
#import "HomeCommerceCell.h"
#import "CommerceDetailController.h"
#import "SearchCommerceController.h"
#import "EntreprenurialController.h"
#import "ComprehensiveServerController.h"
#import "NewsListController.h"
#import "MineCommerceController.h"
#import "MyGuideController.h"
@interface NewHomePageController ()<UITableViewDelegate,UITableViewDataSource,RCIMUserInfoDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) HomeSectionView *sectionView;
@property (nonatomic) NSArray *commerceArray;
@property (nonatomic) NSArray *poseterArray;
@end

@implementation NewHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"天寻科技";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self getCommerceList];
    [self getCycleImageArray];
    
    if (USER_SINGLE.token.length > 0) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.member_id,@"member_id",USER_SINGLE.token,@"token",USER_SINGLE.role_type,@"RoleType", nil];
        [HTTPREQUEST_SINGLE postWithURLStringHeaderAndBody:SH_GET_IM_TOKEN headerParameters:dic bodyParameters:nil withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
            if ([responseDic[@"code"] integerValue] == 200) {
                [[RCIM sharedRCIM] connectWithToken:responseDic[@"token"]     success:^(NSString *userId) {
                    [[RCIM sharedRCIM] setUserInfoDataSource:self];
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                } error:^(RCConnectErrorCode status) {
                    //                    NSLog(@"登陆的错误码为:%d", status);
                } tokenIncorrect:^{
                    //token过期或者不正确。
                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                    NSLog(@"token错误");
                }];
            }
            NSLog(@"%@",responseDic);
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
    }
}
-(void)getCommerceList{
    __block NewHomePageController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",@"",@"commerce_name",@"",@"commerce_type",@"1",@"page",@"",@"ios", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_HOME_COMMERCES parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            blockSelf.commerceArray = responseDic[@"data"];
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getCycleImageArray{
    __block NewHomePageController *blockSelf = self;
    [HTTPREQUEST_SINGLE getWithURLString:GROUND_SCROLL_IMAGE parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSString *imgURLString = responseDic[@"data"][@"square_img"];
        NSArray *imageurlArray = [imgURLString componentsSeparatedByString:@"|"];
        NSMutableArray * imageURLArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i <= imageurlArray.count - 1; i ++) {
            NSString *imageString = [NSString stringWithFormat:@"%@%@",@"https://app.tianxun168.com",imageurlArray[i]];
            [imageURLArray addObject:imageString];
        }
        blockSelf.poseterArray = imageURLArray;
       [blockSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.commerceArray[indexPath.row];
    CommerceDetailController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceDetailController"];
    vc.commerceId = [NSString stringWithFormat:@"%ld",[dic[@"commerce_id"] integerValue]];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self FouctionForCell:indexPath.row];
    }else{
        HomeCommerceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HomeCommerceCell"];
        NSDictionary *dic = self.commerceArray[indexPath.row];
        cell.titleLabel.text = dic[@"commerce_name"];
        NSString *commerceType = @"";
        switch ([dic[@"commerce_type"] integerValue]) {
            case 1:{
                commerceType = @"行业协会";
            }break;
            case 2:{
                commerceType = @"综合型商会";
            }break;
            case 3:{
                commerceType = @"地方商会";
            }break;
            case 4:{
                commerceType = @"异地商会";
            }break;
            default:
                break;
        }
        cell.contentLabel.text = commerceType;
        cell.cityLabel.text = [NSString stringWithFormat:@"  %@",dic[@"commerce_location"]];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@名会员",dic[@"ct"]];
         [cell.cellView makeCorner:5];
        if ([dic[@"commerce_logo"] isKindOfClass:[NSNull class]]) {
             [cell.commerceImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }else{
            [cell.commerceImage sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"commerce_logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    [cell.commerceImage setImage:[UIImage imageNamed:@"default_avatar"]];
                }
            }];
        }
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 177;
        }else if (indexPath.row == 1){
            return 103;
        }else{
            return 80;
        }
    }else{
        return 95;
    }
}
-(UITableViewCell *)FouctionForCell :(NSInteger )row{
    __block NewHomePageController *blockSelf = self;
    switch (row) {
        case 0:{
            PosterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PosterCell"];
            cell.posterArray = self.poseterArray;
            [cell setupCycleScrollview];
            return cell;
        }break;
        case 1:{
            EightBlockCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EightBlockCell"];
            [cell.commerceView bk_whenTapped:^{
                SearchCommerceController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchCommerceController"];
                [blockSelf.navigationController pushViewController:vc animated:YES];
            }];
            [cell.chuangyeView bk_whenTapped:^{
                EntreprenurialController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"EntreprenurialController"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [cell.zongheView bk_whenTapped:^{
                ComprehensiveServerController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"ComprehensiveServerController"];
                [blockSelf.navigationController pushViewController:vc animated:YES];
            }];
            [cell.xinzhengView bk_whenTapped:^{
                NewsListController *vc = [[UIStoryboard storyboardWithName:@"NewsList" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsListController"];
                [blockSelf.navigationController pushViewController:vc animated:YES];
            }];
            return cell;
        }break;
        case 2:{
            TwoBlockCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TwoBlockCell"];
            [cell.oneView bk_whenTapped:^{
                MineCommerceController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"MineCommerceController"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [cell.twoView bk_whenTapped:^{
                MyGuideController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"MyGuideController"];
                vc.title = @"使用指南";
                [self.navigationController pushViewController:vc animated:YES];
            }];
            return cell;
        }break;
        default:
            return nil;
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return self.commerceArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 55;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section== 0) {
        return nil;
    }else{
        return self.sectionView;
    }
}
-(HomeSectionView *)sectionView{
    if (_sectionView == nil) {
        _sectionView = [[NSBundle mainBundle] loadNibNamed:@"homeview" owner:self options:nil][1];
        
    }
    return _sectionView;
}
@end
