//
//  EducationChanController.m
//  TXProject
//
//  Created by Sam on 2019/1/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EducationChanController.h"

#import "OneEducationCell.h"
#import "TwoEducationCell.h"
#import "SchoolListController.h"
@interface EducationChanController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *avtiveImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSArray *cellArray;
@property (nonatomic) NSDictionary *numberDic;
@end

@implementation EducationChanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.title = @"产教融";
    self.cellArray = @[@{@"title":@"累计对接数",@"image":@"star"},@{@"title":@"对接成功数",@"image":@"book"},@{@"title":@"院校",@"image":@"buildings"},@{@"title":@"专家教授",@"image":@"index_expert"},@{@"title":@"学生",@"image":@"student"},@{@"title":@"人才需求",@"image":@"persons"},@{@"title":@"技术需求",@"image":@"index_demand"},@{@"title":@"科研团队",@"image":@"index_team"},@{@"title":@"成果交易",@"image":@"mechanics"},@{@"title":@"实习实训",@"image":@"team"},@{@"title":@"双创服务",@"image":@"wound_service"},@{@"title":@"全媒中心",@"image":@"full_medium"}];
    [HTTPREQUEST_SINGLE getWithURLString:SH_EDUCATION_NUMBER parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            self.numberDic = responseDic[@"data"];
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)viewDidLayoutSubviews{
    self.collectionView.frame = CGRectMake(0, 30, ScreenW, 70*kScale*self.cellArray.count/2);
    [self.avtiveImage setCenter:CGPointMake(ScreenW/2, (self.collectionView.frame.origin.y+self.collectionView.frame.size.height)+self.avtiveImage.frame.size.height/2)];
}

// 设置集合视图有多少个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cellArray.count;
}


#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(375*kScale/2,70*kScale);
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.cellArray[indexPath.row];
    if (indexPath.row == 0 || indexPath.row == 1) {
        OneEducationCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"OneEducationCell" forIndexPath:indexPath];
        cell.titleLabel.text = dic[@"title"];
        [cell.cellImage setImage:[UIImage imageNamed:dic[@"image"]]];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor colorWithRGB:0xE6E6E6].CGColor;
        if (indexPath.row == 0) {
            cell.cellNumber.text = [NSString stringWithFormat:@"%@",self.numberDic[@"grand_total"]] ;
        }else{
            cell.cellNumber.text = [NSString stringWithFormat:@"%@", self.numberDic[@"success_count"]];
        }
        return cell;
    }else{
        TwoEducationCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"TwoEducationCell" forIndexPath:indexPath];
        cell.titleLabel.text = dic[@"title"];
        [self setupNumberToCell:cell andIndexPath:indexPath];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor colorWithRGB:0xE6E6E6].CGColor;
        [cell.imageCell setImage:[UIImage imageNamed:dic[@"image"]]];
        return cell;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        SchoolListController *vc = [[UIStoryboard storyboardWithName:@"SchoolMessage" bundle:nil] instantiateViewControllerWithIdentifier:@"SchoolListController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)setupNumberToCell : (TwoEducationCell *)cell andIndexPath :(NSIndexPath*)indexPath {
  
    switch (indexPath.row) {
        case 2:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"academy_count"]];
            break;
        case 3:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"expert_count"]];
            break;
        case 4:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"student_count"]];
            break;
        case 5:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"talent_count"]];
            break;
        case 6:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"technology_count"]];
            break;
        case 7:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"team_count"]];
            break;
        case 8:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"result_count"]];
            break;
        case 9:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"jobs_count"]];
            break;
        case 10:
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.numberDic[@"project_count"]];
            break;
        case 11:
            cell.numberLabel.text = @"";
            break;
    
        default:
            break;
    }
}
@end
