//
//  NSObject+JSModel.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/8.
//  Copyright © 2019 we. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSModel <NSObject>

@optional

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;

@end

@interface NSObject (JSModel)

+ (nullable instancetype)js_modelWithJson:(id)json;

@end

NS_ASSUME_NONNULL_END
