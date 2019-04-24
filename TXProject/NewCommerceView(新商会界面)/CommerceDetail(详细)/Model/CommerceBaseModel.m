//
//  CommerceBaseModel.m
//  TXProject
//
//  Created by Sam on 2019/4/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CommerceBaseModel.h"

@implementation CommerceBaseModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if (oldValue == [NSNull null]) {
        if ([oldValue isKindOfClass:[NSArray class]]) {
            return  @[];
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            return @{};
        }else{
            return @"";
        }
    }
    return oldValue;
}
@end
