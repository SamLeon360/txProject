//
//  NewHomePageController.m
//  TXProject
//
//  Created by Sam on 2019/2/12.
//  Copyright © 2019 sam. All rights reserved.
//
#import "LibraryController.h"
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
#import "InvestmentDetailController.h"
#import "SmallWXCell.h"
#import "SmallWXController.h"
#import "UpdateAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import "StudentJobController.h"
#import "EduHomeViewController.h"
#import "ShareAlertView.h"
#import "TUIKit.h"

#import "TIMManager.h"
@interface NewHomePageController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) HomeSectionView *sectionView;
@property (nonatomic) UpdateAlertView *updateAlertView;
@property (nonatomic) NSArray *commerceArray;
@property (nonatomic) NSArray *poseterArray;
@property (nonatomic) ShareAlertView *shareAlertView;
@property (nonatomic) NSMutableArray *cycleImageArray;

@end

@implementation NewHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"首页";
    self.cycleImageArray = [NSMutableArray arrayWithCapacity:0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self setupItems];
    [self getCommerceList];
    [self getCycleImageArray];
    [self getVersion];
    if (USER_SINGLE.token.length > 0) {
//        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.member_id,@"member_id",USER_SINGLE.token,@"token",USER_SINGLE.role_type,@"RoleType", nil];
        
        NSString *url =[NSString stringWithFormat: @"https://app.tianxun168.com/h5_v3/index.php?s=/api/Im/getSig&mobile=%@",USER_SINGLE.phone];
        [TSRequestTool GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
            TUIKitConfig *config = [TUIKitConfig defaultConfig];
            [[TUIKit sharedInstance] initKit:1400209730 accountType:@"36862" withConfig:config];
            [[TUIKit sharedInstance] loginKit:USER_SINGLE.phone userSig:responseObject[@"data"] succ:^{
                NSLog(@"成功");
            } fail:^(int code, NSString *msg) {
                NSLog(@"%@",msg);
            }];
//            TIMLoginParam * login_param = [[TIMLoginParam alloc ]     init];
//            login_param.identifier = USER_SINGLE.member_name;
//            login_param.userSig = responseObject[@"data"];
//          login_param.appidAt3rd = @"36862";
//            [[TIMManager sharedInstance] login:login_param succ:^{
//                NSLog(@"成功");
//            }fail:^(int code,NSString *msg) {
//                NSLog(@"%@",msg);
//            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
//        [HTTPREQUEST_SINGLE postWithURLStringHeaderAndBody:SH_GET_IM_TOKEN headerParameters:dic bodyParameters:nil withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
//            if ([responseDic[@"code"] integerValue] == 200) {
        
        
                
               
//                [[RCIM sharedRCIM] connectWithToken:responseDic[@"token"]     success:^(NSString *userId) {
//                    [[RCIM sharedRCIM] setUserInfoDataSource:self];
//                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//                } error:^(RCConnectErrorCode status) {
//                    //                    NSLog(@"登陆的错误码为:%d", status);
//                } tokenIncorrect:^{
//                    //token过期或者不正确。
//                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//                    NSLog(@"token错误");
//                }];
//            }
//            NSLog(@"%@",responseDic);
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error);
//
//        }];
    }
    
}
-(void)getVersion{
    [HTTPREQUEST_SINGLE getWithURLString:SH_GET_VERSION parameters:nil withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
        NSString *newest = responseDic[@"data"][@"ios_newest_versions"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        if ([self compareVersion:app_Version to:newest] == -1 ) {
            self.updateAlertView.NewVersionLabel.text = [NSString stringWithFormat:@"最新版本:%@",newest];
            self.updateAlertView.currentVersionLabel.text = [NSString stringWithFormat:@"当前版本:%@",app_Version];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
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
    NSString *url = @"https://app.tianxun168.com/h5_v3/index.php?s=/api/Ads/index&position=4";
    [TSRequestTool POST:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject[@"data"];
        [blockSelf.cycleImageArray addObjectsFromArray:arr];
        NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0 ; i < blockSelf.cycleImageArray.count; i++) {
            NSDictionary *dic = blockSelf.cycleImageArray[i];
            [imageArr addObject: dic[@"image"][@"file_path"]];
        }
        self.poseterArray = imageArr;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
            return 206;
        }else if(indexPath.row == 3){
            return 163;
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
            cell.vController = self;
            cell.scrollArray = self.cycleImageArray;
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
            [cell.zhaoshangView bk_whenTapped:^{
                InvestmentDetailController *vc = [[UIStoryboard storyboardWithName:@"Investment" bundle:nil] instantiateViewControllerWithIdentifier:@"InvestmentDetailController"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [cell.peopleNeedView bk_whenTapped:^{
                StudentJobController *vc = [[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"StudentJobController"];
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }];
            [cell.libraryView bk_whenTapped:^{
                LibraryController *vc =[[UIStoryboard storyboardWithName:@"Library" bundle:nil] instantiateViewControllerWithIdentifier:@"LibraryController"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [cell.EduProView bk_whenTapped:^{
                EduHomeViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"EduHomeViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            return cell;
        }break;
        case 3:{
            SmallWXCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SmallWXCell"];
            [cell.smallWX makeCorner:10];
            cell.smallWX.userInteractionEnabled = YES;
            [cell.smallWX bk_whenTapped:^{
                SmallWXController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"SmallWXController"];
                [self.navigationController pushViewController:vc
                                                     animated:YES];
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
        return 4;
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
        [_sectionView.checkLabel bk_whenTapped:^{
            SearchCommerceController *searchVC = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchCommerceController"];
            [self.navigationController pushViewController:searchVC animated:YES];
        }];
        
    }
    return _sectionView;
}
-(UpdateAlertView *)updateAlertView{
    if (_updateAlertView == nil) {
        _updateAlertView = [[NSBundle mainBundle] loadNibNamed:@"UpdateAlertView" owner:self options:nil][0];
        _updateAlertView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        [_updateAlertView setBackgroundColor: [[UIColor whiteColor] colorWithAlphaComponent:0]];
        [_updateAlertView.backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        [_updateAlertView.cancelBtn bk_whenTapped:^{
            exit(0);
        }];
        
        [_updateAlertView.updateBtn bk_whenTapped:^{
            NSString * urlStr = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?mt=8",@"1454486224"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:_updateAlertView];
    }
    return _updateAlertView;
}
-(void)setupItems{
    UIBarButtonItem *item1 = [self itemWithImageName:@"home_kefu_icon" highImageName:@"home_kefu_icon" target:self action:@selector(callKefu)];
    UIBarButtonItem *item2 = [self itemWithImageName:@"home_share_icon" highImageName:@"home_share_icon" target:self action:@selector(shareURL)];
      self.navigationItem.rightBarButtonItems  = @[item2,  item1];
}
-(void)callKefu{
    [CustomFountion callPhone:@"0760-88587021" andView:self.view];
}
-(void)shareURL{
    self.shareAlertView.hidden = NO;
}

-(UIBarButtonItem *)itemWithImageName:(NSString *)ImageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
 {
     //自定义UIView
     UIButton *btn=[[UIButton alloc]init];

     //设置按钮的背景图片（默认/高亮）
     [btn setBackgroundImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
//     [btn setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
     //设置按钮的尺寸和图片一样大，使用了UIImage的分类
     btn.size=btn.currentBackgroundImage.size;
     [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

     return [[UIBarButtonItem alloc]initWithCustomView:btn];

 }

-(ShareAlertView *)shareAlertView{
    if (_shareAlertView == nil) {
        _shareAlertView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][1];
        _shareAlertView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _shareAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:_shareAlertView];
        [_shareAlertView.mainView makeCorner:5];
        [_shareAlertView.cancelView makeCorner:5];
        _shareAlertView.hidden = YES;
        __block NewHomePageController *blockSelf = self;
        [_shareAlertView.cancelView bk_whenTapped:^{
            blockSelf.shareAlertView.hidden = YES;
        }];
        [_shareAlertView.cycleView bk_whenTapped:^{
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
            [shareParams SSDKSetupShareParamsByText:@""
                                             images:self->_shareAlertView.shareImage.image
                                                url:[NSURL URLWithString:@""]
                                              title:@"天寻商盟" type:SSDKContentTypeImage];
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                
            }];
        }];
        [_shareAlertView.wechatView bk_whenTapped:^{
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
           
            [shareParams SSDKSetupShareParamsByText:@""
                                             images:self->_shareAlertView.shareImage.image
                                                url:[NSURL URLWithString:@""]
                                              title:@"天寻商盟"
                                        type:SSDKContentTypeImage];
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                
            }];
        }];
    }
    return _shareAlertView;
}
@end
