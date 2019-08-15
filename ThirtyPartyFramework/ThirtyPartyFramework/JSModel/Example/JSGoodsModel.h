//
//  JSGoodsModel.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/8.
//  Copyright © 2019 we. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSGoodsInfoModel : NSObject
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *name;
@end

@interface JSGoodsModel : NSObject
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSNumber *number;
@property(nonatomic,strong) NSDate *date;
@property(nonatomic,strong) NSArray *array;
@property(nonatomic,strong) NSMutableArray *mutArray;
@property(nonatomic,strong) JSGoodsInfoModel *dictionary;
@property(nonatomic,strong) JSGoodsInfoModel *mutDictionary;
@property(nonatomic,strong) NSDictionary *info;

@property(nonatomic,assign) int  intValue;
@property(nonatomic,assign) BOOL boolValue;
@property(nonatomic,assign) float floatValue;
@property(nonatomic,assign) double doubleValue;


@end

NS_ASSUME_NONNULL_END
