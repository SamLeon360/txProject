//
//  TXChatListController.m
//  TXProject
//
//  Created by Sam on 2019/1/10.
//  Copyright © 2019 sam. All rights reserved.
//

#import "TXChatListController.h"
#import "UITabBarItem+DKSBadge.h"
#import "UITabBar+DKSTabBar.h"
@interface TXChatListController ()<RCIMConnectionStatusDelegate,RCIMUserInfoDataSource>
@end
@implementation  TXChatListController

-(void)viewDidLoad{
    [super viewDidLoad]; self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"聊天";
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
//    [self refreshConversationTableViewIfNeeded];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
//    [RCIM sharedRCIM].receiveMessageDelegate = self;
//    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:USER_SINGLE.member_id name:USER_SINGLE. portrait:@"用户头像的url"];
    // 设置消息体内是否携带用户信息
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
  

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (totalUnreadCount > 0) {
        
    }else{
        [self.tabBarController.tabBar hideBadgeIndex:1];
    }
    
}
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    [self.conversationListTableView reloadData];
   
}
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    if ([userId isEqualToString:@"当前登录用户的融云id"]) {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:USER_SINGLE.member_name portrait:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,[NSString stringWithFormat:@"/uploads/mem_info/%@/%@.jpg",USER_SINGLE.member_id,USER_SINGLE.member_id]]]);
    }else
    {
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"member_id", nil];
        [HTTPREQUEST_SINGLE postWithURLStringHeaderAndBody:SH_MINE_MESSAGE headerParameters:nil bodyParameters:params withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
            
            if ([responseDic[@"code"] integerValue] == 0) {
               return completion([[RCUserInfo alloc] initWithUserId:userId name:responseDic[@"data"][@"member_name"] portrait:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,[NSString stringWithFormat:@"/uploads/mem_info/%@/%@.jpg",userId,userId]]]);
            }else if([responseDic[@"code"] integerValue] == -1001){
                [USER_SINGLE logout];
                return completion([[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,[NSString stringWithFormat:@"/uploads/mem_info/%@/%@.jpg",userId,userId]]]);
            }
        } failure:^(NSError *error) {
              return   completion([[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,[NSString stringWithFormat:@"/uploads/mem_info/%@/%@.jpg",userId,userId]]]);
        }];
        
    }
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

@end
