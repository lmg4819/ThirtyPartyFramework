//
//  JSGoodsModel.m
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/8.
//  Copyright © 2019 we. All rights reserved.
//

#import "JSGoodsModel.h"


@implementation JSGoodsModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"array":[JSGoodsInfoModel class],
             @"mutArray":[JSGoodsInfoModel class],
             @"info":[JSGoodsInfoModel class]
             };
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             @"ID":@"id"
             };
}

@end

@implementation JSGoodsInfoModel


@end
