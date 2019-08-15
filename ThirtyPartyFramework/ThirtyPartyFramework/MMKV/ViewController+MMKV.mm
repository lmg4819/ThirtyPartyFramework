//
//  ViewController+MMKV.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController+MMKV.h"
#import <MMKV.h>
#include <execinfo.h>

@implementation ViewController (MMKV)

- (void)mmkv_customInitMethod
{
    //    //关闭MMKV控制台打印的自带的辅助日志信息
    [MMKV setLogLevel:MMKVLogNone];
    
    [self kvCreateMethod];
    
    [self compareMMKVWithNSUesrDefault];
    
    [self cLanguageDataType];
    
    [self ocLanguageDataType];
    
    [self kvMigrateFromUserDefaults];
    
    [[MMKV defaultMMKV] clearAll];
    
    NSLog(@"count:%zu-----totalSize:%zu------actualSize:%zu-----allKeys:%@",[[MMKV defaultMMKV] count],[[MMKV defaultMMKV] totalSize],[[MMKV defaultMMKV] actualSize],[[MMKV defaultMMKV] allKeys]);
}


/*
 写入10万个数据所用的时间
 MMKV : 198.487043ms
 NSUserDefaults : 13829.244971ms
 */
- (void)compareMMKVWithNSUesrDefault
{
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    MMKV *customKV = [MMKV mmkvWithID:@"cn.meicai"];
    for (int i=0; i<100000; i++) {
        [customKV setInt32:i forKey:@"int32"];
    }
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"Linked in %f ms", linkTime *1000.0);
    NSLog(@"------%d--------",[customKV getInt32ForKey:@"int32"]);
    
    
    //    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    //    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //    for (int i=0; i<100000; i++) {
    //        [userDefault setInteger:i forKey:@"int32"];
    //    }
    //    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    //    NSLog(@"Linked in %f ms", linkTime *1000.0);
    //    NSLog(@"------%ld--------",(long)[userDefault integerForKey:@"int32"]);
    
}
/*
 //以下四种创建方法是完全等价的,创建的是同一个MMKV实例
 */
- (void)kvCreateMethod
{
    //MMKV文件存储的默认为~/Documents/mmkv
    NSString *basePath = [MMKV mmkvBasePath];
    
    //修改文件存储的默认路径，在创建MMKV实例之前设置
    [MMKV setMMKVBasePath:basePath];
    
    //第一种创建方法
    MMKV *defaultKV1 = [MMKV defaultMMKV];
    
    //第二种创建方法
    MMKV *defaultKV3 = [MMKV mmkvWithID:@"mmkv.default"];
    
    //第三种创建方法
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    string = [string stringByAppendingPathComponent:@"mmkv"];
    MMKV *defaultKV4 = [MMKV mmkvWithID:@"mmkv.default" relativePath:string];
    
    //第四种创建方法
    MMKV *defaultKV2 = [MMKV mmkvWithID:@"mmkv.default" cryptKey:nil relativePath:string];
    
    [defaultKV1 class];
    [defaultKV2 class];
    [defaultKV3 class];
    [defaultKV4 class];
 
}


/*
 支持以下 C 语语言基础类型：
 bool、int32、int64、uint32、uint64、float、double
 */
- (void)cLanguageDataType
{
    MMKV *mmkv = [MMKV defaultMMKV];
    
    [mmkv setBool:YES forKey:@"bool"];
    NSLog(@"bool:%d", [mmkv getBoolForKey:@"bool"]);
    
    [mmkv setInt32:-1024 forKey:@"int32"];
    NSLog(@"int32:%d", [mmkv getInt32ForKey:@"int32"]);
    
    [mmkv setUInt32:std::numeric_limits<uint32_t>::max() forKey:@"uint32"];
    NSLog(@"uint32:%u", [mmkv getUInt32ForKey:@"uint32"]);
    
    [mmkv setInt64:std::numeric_limits<int64_t>::min() forKey:@"int64"];
    NSLog(@"int64:%lld", [mmkv getInt64ForKey:@"int64"]);
    
    [mmkv setUInt64:std::numeric_limits<uint64_t>::max() forKey:@"uint64"];
    NSLog(@"uint64:%llu", [mmkv getInt64ForKey:@"uint64"]);
    
    [mmkv setFloat:-3.1415926 forKey:@"float"];
    NSLog(@"float:%f", [mmkv getFloatForKey:@"float"]);
    
    [mmkv setDouble:std::numeric_limits<double>::max() forKey:@"double"];
    NSLog(@"double:%f", [mmkv getDoubleForKey:@"double"]);
    
}
/*
 支持以下 ObjC 类型：
 NSString、NSData、NSDate
 */
- (void)ocLanguageDataType
{
    //cryptKey  根据此秘钥创建AES加密器,加密后的数据存取方法不变，和未加密的一样
    MMKV *mmkv = [MMKV mmkvWithID:@"cn.meicai" cryptKey:[@"crypt" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [mmkv setString:@"hello, mmkv" forKey:@"string"];
    NSLog(@"string:%@ defaultValue:%@", [mmkv getStringForKey:@"string"],[mmkv getStringForKey:@"string111" defaultValue:@"mmmmmmmmmmmmmmmm"]);
    
    [mmkv setObject:nil forKey:@"string"];
    NSLog(@"string after set nil:%@, containsKey:%d",
          [mmkv getObjectOfClass:NSString.class
                          forKey:@"string"],
          [mmkv containsKey:@"string"]);
    
    [mmkv setDate:[NSDate date] forKey:@"date"];
    NSLog(@"date:%@ defaultValue:%@", [mmkv getDateForKey:@"date"],[mmkv getDateForKey:@"date111" defaultValue:[NSDate date]]);
    
    [mmkv setData:[@"hello, mmkv again and again" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"data"];
    NSData *data = [mmkv getDataForKey:@"data"];
    NSLog(@"data:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

/*
 从NSUserDefault迁移数据到MMKV的实例
 */
- (void)kvMigrateFromUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:@"hello world" forKey:@"string"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MMKV *userDefaultKV = [MMKV mmkvWithID:@"NSUserDefault"];
    [userDefaultKV migrateFromUserDefaults:[NSUserDefaults standardUserDefaults]];
    [userDefaultKV enumerateKeys:^(NSString * _Nonnull key, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"string"]) {
            NSLog(@"string value is : %@",[userDefaultKV getStringForKey:key]);
            NSLog(@"string value is : %@",[userDefaultKV getObjectOfClass:[NSString class] forKey:key]);
            NSLog(@"string value is : %@",[userDefaultKV getObjectOfClass:[NSNumber class] forKey:key]);
            *stop = YES;
        }
    }];
}
@end
