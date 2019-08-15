//
//  ViewController+JSModel.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController+JSModel.h"
#import "JSGoodsModel.h"
#import "NSObject+JSModel.h"

@implementation ViewController (JSModel)

- (void)js_customInitMethod
{
    NSDictionary *dictionary = @{@"ID":@"1234567",@"name":@"hello"};
    NSArray *array = @[dictionary,dictionary];
    NSDictionary *dict = @{@"id":@1234567,@"number":@145,@"date":@"2019-08-07 11:22:06",@"array":array,@"mutArray":array.mutableCopy,@"info":dictionary,@"dictionary":dictionary,@"mutDictionary":dictionary.mutableCopy,
                           @"intValue":@(111),@"boolValue":@(222.22),@"floatValue":@"333.33",@"doubleValue":@(444.44)
                           };
    
    JSGoodsModel *model = [JSGoodsModel js_modelWithJson:dict];
    if (model.ID) {
        NSLog(@"%@",model.ID);
    }
}

@end
