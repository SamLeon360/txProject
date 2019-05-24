//
//  AuthorityManage.m
//  TXProject
//
//  Created by Sam on 2019/5/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import "AuthorityManage.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <UserNotifications/UserNotifications.h>

@implementation AuthorityManage

///检测麦克风状态
+(void)detectionMicrophoneState:(void(^)(BOOL isAvalible))authorizedBlock
{
    __block BOOL isAvalible = NO;
    NSString *mediaType = AVMediaTypeAudio;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    //用户尚未授权->申请权限
    if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted)
            {
                isAvalible = YES;
                if (authorizedBlock)
                {
                    authorizedBlock(isAvalible);
                }
            }}];
    }
    //用户已经授权
    else if (authStatus == AVAuthorizationStatusAuthorized)
    {
        isAvalible = YES;
        if (authorizedBlock)
        {
            authorizedBlock(isAvalible);
        }
    }
    //用户拒绝授权
    else
    {
        //提示用户开启麦克风权限
        isAvalible = NO;
        if (authorizedBlock)
        {
            authorizedBlock(isAvalible);
        }
    }
}

///检测相册访问权限
+(void)detectionPhotoState:(void(^)(BOOL isAvalible))authorizedBlock
{
    __block BOOL  isAvalible = NO;
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    //用户尚未授权
    if (authStatus == PHAuthorizationStatusNotDetermined)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized)
            {
                isAvalible = YES;
                if (authorizedBlock)
                {
                    authorizedBlock(isAvalible);
                }
            }}];
    }
    //用户已经授权
    else if (authStatus == PHAuthorizationStatusAuthorized)
    {
        isAvalible = YES;
        if (authorizedBlock)
        {
            authorizedBlock(isAvalible);
        }
    }
    //用户拒绝授权
    else
    {
        //提示用户开启相册权限
        isAvalible = NO;
        if (authorizedBlock)
        {
            authorizedBlock(isAvalible);
        }
    }
}

///检测相机访问权限
+(void)detectionCameraState:(void(^)(BOOL isAvalible))authorizedBlock
{
    __block BOOL  isAvalible = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //用户尚未授权
    if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted)
            {
                isAvalible = YES;
                if (authorizedBlock)
                {
                    authorizedBlock(isAvalible);
                }
            }
        }];
    }
    //用户已经授权
    else if (authStatus == AVAuthorizationStatusAuthorized)
    {
        isAvalible = YES;
        if (authorizedBlock)
        {
            authorizedBlock(isAvalible);
        }
    }
    //用户拒绝授权
    else
    {
        //提示用户开启相机权限
        isAvalible = NO;
        if (authorizedBlock)
        {
            authorizedBlock(isAvalible);
        }
    }
}

///检测通知权限
+(void)detectionNotificationState:(void(^)(BOOL isAvalible))authorizedBlock
{
    __block BOOL  isAvalible = NO;
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 10) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        } else {
            // Fallback on earlier versions
        }
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                //用户尚未授权
                if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        if (granted)
                        {
                            isAvalible = YES;
                            if (authorizedBlock)
                            {
                                authorizedBlock(isAvalible);
                            }
                        }
                    }];
                }
                //用户已经授权
                else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized)
                {
                    isAvalible = YES;
                    if (authorizedBlock)
                    {
                        authorizedBlock(isAvalible);
                    }
                }
                //用户拒绝授权
                else
                {
                    isAvalible = NO;
                    if (authorizedBlock)
                    {
                        authorizedBlock(isAvalible);
                    }
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    }
    else
    {
        //用户拒绝授权
        if ([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone)
        {
            //提示用户开启通知权限
            isAvalible = NO;
            if (authorizedBlock)
            {
                authorizedBlock(isAvalible);
            }
        }
        else
        {
            isAvalible = YES;
            if (authorizedBlock)
            {
                authorizedBlock(isAvalible);
            }
        }
    }
}


@end
