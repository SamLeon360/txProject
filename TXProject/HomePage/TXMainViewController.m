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
#import "TXChatListController.h"
#import "NewMineMessageTableViewController.h"
#import "NewHomePageController.h"
#import "UITabBar+DKSTabBar.h"
@interface TXMainViewController ()<UITabBarControllerDelegate,RCIMReceiveMessageDelegate>

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
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
    [RCIM sharedRCIM].receiveMessageDelegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
     
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (totalUnreadCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tabBar showBadgeIndex:1];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabBar hideBadgeIndex:1];
        });
        
    }
    
}
- (void)setupSubviews
{
    //主页
    NSLog(@"---%@",USER_SINGLE.default_commerce_id);
  
    NewHomePageController *homeVC = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"NewHomePageController"];
        
    [self addChildViewController:homeVC
                               image:[[UIImage imageNamed:@"shetuan_no_select"]scaleToSize:CGSizeMake(21, 20)]
                       selectedImage:[[UIImage imageNamed:@"shetuan_select"] scaleToSize:CGSizeMake(21, 20)]
                               title:@"广场"];
    
    HomeServerController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeServerController"];

    [self addChildViewController:vc
                           image:[[UIImage imageNamed:@"server_no_select"] scaleToSize:CGSizeMake(19, 20)]
                   selectedImage:[[UIImage imageNamed:@"server_select"] scaleToSize:CGSizeMake(19, 20)]
                           title:@"应用"];
    
    TXChatListController *webVc1 = [[TXChatListController alloc] init];
    [self addChildViewController:webVc1
                           image:[[UIImage imageNamed:@"chat_no_select"] scaleToSize:CGSizeMake(19, 19)]
                   selectedImage:[[UIImage imageNamed:@"chat_select"] scaleToSize:CGSizeMake(19, 19)]
                           title:@"聊天"];
   
    
    TXWebViewController *webVc2 = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    webVc2.intype = shop_cycle;
    [self addChildViewController:webVc2
                               image:[[UIImage imageNamed:@"cycle_no_select"] scaleToSize:CGSizeMake(18, 18)]
                       selectedImage:[[UIImage imageNamed:@"cycle_select"] scaleToSize:CGSizeMake(18, 18)]
                               title:@"商圈"];
    
    
    //我
    NewMineMessageTableViewController *mineVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"NewMineMessageTableViewController"];
    [self addChildViewController:mineVC
                           image:[[UIImage imageNamed:@"me_no_select"] scaleToSize:CGSizeMake(18, 21)]
                   selectedImage:[[UIImage imageNamed:@"me_select"] scaleToSize:CGSizeMake(18, 21)]
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
    [childViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    childViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
    childViewController.tabBarItem.accessibilityFrame = CGRectZero;
    [self addChildViewController:nav];
    nav.tabBarItem.title = title;
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger tabSeledIndex = tabBarController.selectedIndex;
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
}
-(void)gotoReLogin{
    USER_SINGLE.token = @"";
    [USER_SINGLE logout];
}

@end
