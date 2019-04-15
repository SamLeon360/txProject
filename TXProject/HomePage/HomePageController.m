//
//  HomePageController.m
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "HomePageController.h"
#import "HomePageCollectionHeader.h"
#import "HomePageModelCell.h"
#import "LoginBottomView.h"
#import "TXLoginController.h"
#import "AppDelegate.h"
#import "TXLoginNavControllerViewController.h"
#import "TXWebViewController.h"
#import "TXGroundController.h"
#import "EntreprenurialController.h"
#import "MemberListController.h"
#import "CommerceDetailController.h"
#import "CommerceNotifyController.h"
#import "MemberPostController.h"
#import "CommerceNewsController.h"
#import "CommerceWorkController.h"
@interface HomePageController ()<UICollectionViewDelegate,UICollectionViewDataSource,RCIMUserInfoDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *adervtImageArray;
@end

@implementation HomePageController
{
    NSArray *cellBgImageArray;
    
    NSArray *cellBgTitleArray;
    
    NSArray *cellUrlArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    self.navigationItem.title = @"我的社团";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
     self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset =UIEdgeInsetsMake(0,0, 0, 0);
    layout.headerReferenceSize =CGSizeMake(ScreenW,208*kScale);
    
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
    
    cellBgImageArray =@[@"home_icon_1",@"home_icon_2",@"home_icon_3",@"home_icon_4",@"home_icon_5",@"home_icon_6",@"home_icon_7",@"home_icon_8"];
    cellBgTitleArray = SHOW_WEB?@[@"社团介绍",@"会员风采",@"社团通知",@"社团新闻",@"通知反馈",@"社团工作",@"天寻广场",@"会员发布"]:@[@"社团介绍",@"会员风采",@"社团通知",@"社团新闻",@"会员发布"];
    cellUrlArray = @[[NSString stringWithFormat:@"member/detail_platform/%@/1",USER_SINGLE.default_commerce_id],[NSString stringWithFormat:@"member/commerce_friend/%@//1/1/1",USER_SINGLE.default_commerce_id],@"member/commerce_notify//1",@"news_list/1/1/1",@"secretary/send_notify_status/1//1",@"member_work/1",@"home/common_square/1",@"member/application_index/1"];
    [self getScrollImages];
    
}

// 设置每个分区返回多少item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return cellBgTitleArray.count;
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewWillLayoutSubviews{
    
    [self.navigationController setNavigationBarHidden:NO];
    
}
// 设置集合视图有多少个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 208*kScale);
    return size;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    // 如果是头视图
    if (kind == UICollectionElementKindSectionHeader) {
        
        [collectionView registerNib:[UINib nibWithNibName:@"homeview" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageCollectionHeader"];
        HomePageCollectionHeader *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageCollectionHeader" forIndexPath:indexPath];
        tempHeaderView.posterArray = self.adervtImageArray;
        [tempHeaderView setupCycleScrollview];
        return tempHeaderView;
    }else{
        return nil;
    }
    
}
#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(125*kScale,125*kScale);
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}
-(void )getScrollImages{
    __block HomePageController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.default_commerce_id,@"commerce_id", nil];
    [HTTPREQUEST_SINGLE getWithURLString:HOME_SCROLL_IMAGE parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSString *imgURLString = responseDic[@"data"][@"u_recycle_img"];
            NSArray *imageurlArray = [imgURLString componentsSeparatedByString:@"|"];
            blockSelf.adervtImageArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i <= imageurlArray.count - 1; i ++) {
                NSString *imageString = [NSString stringWithFormat:@"%@%@",@"https://app.tianxun168.com",imageurlArray[i]];
                [blockSelf.adervtImageArray addObject:imageString];
            }
            
            [self.collectionView reloadData];
        }
      
    } failure:^(NSError *error) {
        
    }];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomePageModelCell *cell = (HomePageModelCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageModelCell" forIndexPath:indexPath];
    [cell.bgImage setImage:[UIImage imageNamed:cellBgImageArray[indexPath.row]]];
    cell.titleLabel.text = cellBgTitleArray[indexPath.row];
 
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (SHOW_WEB) {
    TXWebViewController *webVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    webVC.webUrl = [NSString stringWithFormat:@"%@%@",WEB_HOST_URL,cellUrlArray[indexPath.row]];
    webVC.title = cellBgTitleArray[indexPath.row];
    if (indexPath.row == 6) {
        if (USER_SINGLE.commerceArray.count > 0) {
            TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
            vc.webUrl = [NSString stringWithFormat:@"%@%@",WEB_HOST_URL,@"home/common_square/1"];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }else{
            TXGroundController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXGroundController"];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
     
    }else if (indexPath.row == 0){
        CommerceDetailController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceDetailController"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (indexPath.row == 1){
        MemberListController *vc = [[UIStoryboard storyboardWithName:@"MemberList" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberListController"];
        vc.checkMember = NO;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (indexPath.row == 2){
        CommerceNotifyController *vc = [[UIStoryboard storyboardWithName:@"CommerceNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceNotifyController"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (indexPath.row == 3){
        CommerceNewsController *vc = [[UIStoryboard storyboardWithName:@"CommerceNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceNewsController"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (indexPath.row == 5){
        CommerceWorkController *vc = [[UIStoryboard storyboardWithName:@"CommerceWork" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceWorkController"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (indexPath.row == 7){
        MemberPostController *vc = [[UIStoryboard storyboardWithName:@"MemberPost" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberPostController"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [self.navigationController pushViewController:webVC animated:YES];
    }else{
        if (indexPath.row == 0){
            CommerceDetailController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceDetailController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            MemberListController *vc = [[UIStoryboard storyboardWithName:@"MemberList" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberListController"];
            vc.checkMember = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            CommerceNotifyController *vc = [[UIStoryboard storyboardWithName:@"CommerceNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceNotifyController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            CommerceNewsController *vc = [[UIStoryboard storyboardWithName:@"CommerceNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceNewsController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 4){
            CommerceWorkController *vc = [[UIStoryboard storyboardWithName:@"CommerceWork" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceWorkController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 5){
            MemberPostController *vc = [[UIStoryboard storyboardWithName:@"MemberPost" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberPostController"];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
}


@end
