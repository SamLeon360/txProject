//
//  AuthorityManage.h
//  TXProject
//
//  Created by Sam on 2019/5/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorityManage : NSObject
//检测麦克风状态
+(void)detectionMicrophoneState:(void(^)(BOOL isAvalible))authorizedBlock;

///检测相册访问权限
+(void)detectionPhotoState:(void(^)(BOOL isAvalible))authorizedBlock;

///检测相机访问权限
+(void)detectionCameraState:(void(^)(BOOL isAvalible))authorizedBlock;

///检测通知权限
+(void)detectionNotificationState:(void(^)(BOOL isAvalible))authorizedBlock;
@end

NS_ASSUME_NONNULL_END
