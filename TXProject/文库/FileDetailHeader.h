//
//  FileDetailHeader.h
//  TXProject
//
//  Created by Sam on 2019/3/27.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *fileIcon;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *fileTime;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *seeNumber;
@property (weak, nonatomic) IBOutlet UILabel *downloadNumber;
@property (weak, nonatomic) IBOutlet UILabel *baseMsg;
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

NS_ASSUME_NONNULL_END
