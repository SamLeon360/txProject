//
//  TXMainViewController.m
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "TXMainViewController.h"
#import "YKNavigationController.h"
#import "HomePageController.h"
#import "UIImage+Custom.h"
#import "HomeServerController.h"
#import "TXGroundController.h"
#import "TXWebViewController.h"
#import "MineViewController.h"

#import "NewMineMessageTableViewController.h"
#import "NewHomePageController.h"
#import "UITabBar+DKSTabBar.h"
#import "ConversationController.h"
#import "SearchCommerceController.h"
#import "UploadCommerceControllerController.h"
@interface TXMainViewController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic) CommerceAlertView *comAlertView;
@property (nonatomic) NSInteger tabIndex;
@end

@implementation TXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [HTTPREQUEST_SINGLE postWithURLString:SH_SHOW_WEB parameters:nil withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
        NSInteger showWeb =[ responseDic[@"data"][@"data"] integerValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",showWeb] forKey:@"ShowWeb"];
    } failure:^(NSError *error) {
        
    }];
  
    [self setupSubviews];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH>=812 ? 48 : 20)];
    [view setBackgroundColor:[UIColor colorWithRGB:0x3e85fb]];
    [self.view addSubview:view];
    self.selectedIndex = 2;
    self.selectedIndex = 0;
    self.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    self.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, 0, 0);
    self.tabBar.opaque = YES;
//    [RCIM sharedRCIM].receiveMessageDelegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            [lastController viewWillDisappear:animated];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    [viewController viewWillAppear:animated];
}
//-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
//     
//    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
//    if (totalUnreadCount > 0) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [self.tabBar showBadgeIndex:1];
//        });
//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tabBar hideBadgeIndex:1];
//        });
//        
//    }
//    
//}
- (void)setupSubviews
{
    //主页
    NSLog(@"---%@",USER_SINGLE.default_commerce_id);
  
    NewHomePageController *homeVC = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"NewHomePageController"];

    [self addChildViewController:homeVC
                               image:[UIImage imageNamed:@"shetuan_no_select"]
                       selectedImage:[UIImage imageNamed:@"shetuan_select"]
                               title:@"首页"];
    
    HomeServerController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeServerController"];
    if ([NSString stringWithFormat:@"%ld",[USER_SINGLE.default_commerce_id integerValue]].length > 0) {
        [self addChildViewController:vc
                               image:[UIImage imageNamed:@"server_no_select"]
                       selectedImage:[UIImage imageNamed:@"server_select"]
                               title:@"应用"];
    }
    
    
    
   
    
    if ([NSString stringWithFormat:@"%ld",[USER_SINGLE.default_commerce_id integerValue]].length > 0) {
        if (SHOW_WEB) {
            TXWebViewController *webVc2 = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
            webVc2.intype = shop_cycle;
            [self addChildViewController:webVc2
                                   image:[UIImage imageNamed:@"cycle_no_select"]
                           selectedImage:[UIImage imageNamed:@"cycle_select"]
                                   title:@"商圈"];
        }
    }
    ConversationController *webVc1 = [[ConversationController alloc] init];
    [self addChildViewController:webVc1
                           image:[UIImage imageNamed:@"chat_no_select"]
                   selectedImage:[UIImage imageNamed:@"chat_select"]
                           title:@"聊天"];
    
    //我
    NewMineMessageTableViewController *mineVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"NewMineMessageTableViewController"];
    [self addChildViewController:mineVC
                           image:[UIImage imageNamed:@"me_no_select"] 
                   selectedImage:[UIImage imageNamed:@"me_select"]
                           title:@"我的"];
    
    
}

#pragma mark 为每个tab设置样式
- (void)addChildViewController:(UIViewController *)childViewController image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    
    childViewController.tabBarItem.title = title;
    [childViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [Common colorFromHexCode:@"000000"]} forState:UIControlStateNormal];
    [childViewController.tabBarItem  setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    childViewController.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childViewController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    YKNavigationController *nav = [[YKNavigationController alloc]initWithRootViewController:childViewController];
    nav.delegate = self;
    [childViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    childViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
    childViewController.tabBarItem.accessibilityFrame = CGRectZero;
    [self addChildViewController:nav];
    nav.tabBarItem.title = title;
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger tabSeledIndex = tabBarController.selectedIndex;
    self.tabIndex = tabSeledIndex;
    if (![USER_SINGLE isLogin] && tabSeledIndex!=0 && tabSeledIndex != 1 ) {
        [self gotoReLogin];
    }
    if (tabSeledIndex == 0 ||tabSeledIndex == 1) {
        [self.navigationController setNavigationBarHidden:NO];
    }else{
        [self.navigationController setNavigationBarHidden: YES];
    }
    if (tabSeledIndex == 4) {
        NOTIFY_POST(@"getDataNetWork");
    }
    if (tabSeledIndex == 1||tabSeledIndex == 2||tabSeledIndex == 3) {
        if ([USER_SINGLE.default_commerce_name isEqualToString:@""]) {
            
             [[UIApplication sharedApplication].keyWindow addSubview:self.comAlertView];
        }
    }
}
-(void)gotoReLogin{
    USER_SINGLE.token = @"";
    [USER_SINGLE logout];
}
-(CommerceAlertView *)comAlertView{
    if (_comAlertView == nil) {
        _comAlertView = [[NSBundle mainBundle] loadNibNamed:@"homeview" owner:self options:nil][2];
        _comAlertView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _comAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_comAlertView.comContentView makeCorner:5];
        __block TXMainViewController *blockSelf = self;
        [_comAlertView.commerceListView bk_whenTapped:^{
            blockSelf.selectedIndex = 0;
            UINavigationController *currentVc = blockSelf.childViewControllers[0];
            [blockSelf.comAlertView removeFromSuperview];
            SearchCommerceController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchCommerceController"];
            [currentVc pushViewController:vc animated:YES];
            
        }];
        [_comAlertView.commerceCreatView bk_whenTapped:^{
            blockSelf.selectedIndex = 0;
            UINavigationController *currentVc = blockSelf.childViewControllers[0];
            [blockSelf.comAlertView removeFromSuperview];
            UploadCommerceControllerController *VC = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadCommerceControllerController"];
            [currentVc pushViewController:VC animated:YES];
            
        }];
        [_comAlertView bk_whenTapped:^{
            blockSelf.selectedIndex = 0;
            [blockSelf.comAlertView removeFromSuperview];
        }];
    }
    return _comAlertView;
}
@end
