//
//  NSObject+JSModel.m
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/8.
//  Copyright © 2019 we. All rights reserved.
//

#import "NSObject+JSModel.h"
#import "JSClassInfo.h"
#import <objc/runtime.h>
#import <objc/message.h>



static void ModelSetNumberToProperty(__unsafe_unretained id model,
                                     __unsafe_unretained NSNumber *number,
                                     __unsafe_unretained JSClassPropertyInfo *info)
{
    switch (info.type) {
        case JSEncodeTypeBool:{
            ((void (*)(id,SEL,bool))(void *) objc_msgSend)(model,info.setter,number.boolValue);
        }
            break;
        case JSEncodeTypeInt8:{
            ((void (*)(id,SEL,int8_t))(void *) objc_msgSend)(model,info.setter,(int8_t)number.charValue);
        }
            break;
        case JSEncodeTypeUInt8:{
            ((void (*)(id,SEL,uint8_t))(void *) objc_msgSend)(model,info.setter,(uint8_t)number.unsignedCharValue);
        }
            break;
        case JSEncodeTypeInt16:{
            ((void (*)(id,SEL,int16_t))(void *) objc_msgSend)(model,info.setter,(int16_t)number.shortValue);
        }
            break;
        case JSEncodeTypeUInt16:{
            ((void (*)(id,SEL,uint16_t))(void *) objc_msgSend)(model,info.setter,(uint16_t)number.unsignedShortValue);
        }
            break;
        case JSEncodeTypeInt32:{
            ((void (*)(id,SEL,int32_t))(void *) objc_msgSend)(model,info.setter,(int32_t)number.intValue);
        }
            break;
        case JSEncodeTypeUInt32:{
            ((void (*)(id,SEL,uint32_t))(void *) objc_msgSend)(model,info.setter,(uint32_t)number.unsignedIntValue);
        }
            break;
        case JSEncodeTypeInt64:{
            if ([number isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id,SEL,int64_t))(void *) objc_msgSend)(model,info.setter,(int64_t)number.stringValue.longLongValue);
            }else{
                ((void (*)(id,SEL,uint64_t))(void *) objc_msgSend)(model,info.setter,(uint64_t)number.longLongValue);
            }
        }
            break;
        case JSEncodeTypeUInt64:{
            if ([number isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id,SEL,int64_t))(void *) objc_msgSend)(model,info.setter,(int64_t)number.stringValue.longLongValue);
            }else{
                ((void (*)(id,SEL,uint64_t))(void *) objc_msgSend)(model,info.setter,(uint64_t)number.longLongValue);
            }
        }
            break;
        case JSEncodeTypeFloat:{
            float f = number.floatValue;
            if (isnan(f) || isinf(f)) f = 0;
            ((void (*)(id,SEL,float))(void *) objc_msgSend)(model,info.setter,f);
        }
            break;
        case JSEncodeTypeDouble:{
            double d = number.doubleValue;
            if (isnan(d) || isinf(d)) d = 0;
            ((void (*)(id,SEL,double))(void *) objc_msgSend)(model,info.setter,d);
        }
            break;
        case JSEncodeTypeLongDouble:{
            long double d = number.doubleValue;
            if (isnan(d) || isinf(d)) d = 0;
            ((void (*)(id,SEL,long double))(void *) objc_msgSend)(model,info.setter,(long double)d);
        }
            break;
        default:
            break;
    }
}

static NSNumber* JSNSNumberCreateFromID(__unsafe_unretained id value)
{
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    if (!value || value == (id)kCFNull) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            return @(((NSString *)value).floatValue);
        }else{
            return @(((NSString *)value).intValue);
        }
    }
    return nil;
}


@implementation NSObject (JSModel)

+ (instancetype)js_modelWithJson:(id)json
{
    NSDictionary *dict = [self p_getDictionaryWithJson:json];
    Class cls = [self class];
    NSObject *one = [cls new];
    if ([one js_modelSetWithDictionary:dict]) {
        return one;
    }
    return nil;
}

+ (NSDictionary *)p_getDictionaryWithJson:(id)json
{
    if (!json || json == (id)kCFNull) {
        return nil;
    }
    NSDictionary *dict = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary *)json;
    }else if ([json isKindOfClass:[NSString class]]){
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]]){
        jsonData = (NSData *)json;
    }
    if (jsonData) {
        dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
    }
    return dict;
}

- (BOOL)js_modelSetWithDictionary:(NSDictionary *)dict
{
    if (!dict || dict == (id)kCFNull) return NO;
    if (![dict isKindOfClass:[NSDictionary class]]) return NO;
    
    JSClassInfo *classInfo = [[JSClassInfo alloc]initWithClass:object_getClass(self)];
    if (classInfo) {
        for (NSString *key in dict.allKeys) {
            id value = dict[key];
            JSClassPropertyInfo *info = classInfo.propertyInfos[key];
            if ([classInfo.cls respondsToSelector:@selector(modelContainerPropertyGenericClass)]) {
                NSDictionary *mapDict = [(id<JSModel>)classInfo.cls  modelContainerPropertyGenericClass];
                for (NSString *mapKey in mapDict.allKeys) {
                    if ([mapKey isEqualToString:key]) {
                        info.genericCls = mapDict[mapKey];
                    }
                }
            }
            if ([classInfo.cls respondsToSelector:@selector(modelCustomPropertyMapper)]) {
                NSDictionary *mapDict = [(id<JSModel>)classInfo.cls modelCustomPropertyMapper];
                for (NSString *mapKey in mapDict.allKeys) {
                    NSString *realKey = mapDict[mapKey];
                    if ([realKey isEqualToString:key]) {
                        info = classInfo.propertyInfos[mapKey];
                    }
                }
            }
            ModelSetValueToProperty(self, value, info);
        }
    }
    return YES;
}

static NSDate *JSNSDateFromString(__unsafe_unretained NSString *string){
    typedef NSDate * (^JSNSDateParseBlock)(NSString *string);
    #define kParserNum 34
    static JSNSDateParseBlock blocks[kParserNum + 1] = {0};
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.dateFormat = @"yyyy-MM-dd";
            blocks[10] = ^(NSString *string){
                return [formatter dateFromString:string];
            };
        }
        {
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter1.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
            
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter2.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            
            NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
            formatter3.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter3.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter3.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
            
            NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
            formatter4.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter4.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter4.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
            
            blocks[19] = ^(NSString *string){
                if ([string characterAtIndex:10] == 'T') {
                    return [formatter1 dateFromString:string];
                } else {
                    return [formatter2 dateFromString:string];
                }
            };
            
            blocks[23] = ^(NSString *string) {
                if ([string characterAtIndex:10] == 'T') {
                    return [formatter3 dateFromString:string];
                } else {
                    return [formatter4 dateFromString:string];
                }
            };
        }
        {
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            
            NSDateFormatter *formatter2 = [NSDateFormatter new];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            
            blocks[20] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[24] = ^(NSString *string) { return [formatter dateFromString:string]?: [formatter2 dateFromString:string]; };
            blocks[25] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[28] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
            blocks[29] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
        }
        {
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
            
            NSDateFormatter *formatter2 = [NSDateFormatter new];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.dateFormat = @"EEE MMM dd HH:mm:ss.SSS Z yyyy";
            
            blocks[30] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[34] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
        }
    });
    if (!string) return nil;
    if (string.length > kParserNum) return nil;
    JSNSDateParseBlock parser = blocks[string.length];
    if (!parser) return nil;
    return parser(string);
    #undef kParserNum
}

static void ModelSetValueToProperty(id model,id value,JSClassPropertyInfo *info){
    if (info.isCNumber) {
        NSNumber *number = JSNSNumberCreateFromID(value);
        ModelSetNumberToProperty(model, number, info);
    }else{
        switch (info.type) {
            
            case JSEncodeTypeBlock:
                
                break;
            case JSEncodeTypeObject:
            {
                switch (info.nsType) {
                    case JSEncodeNSTypeUnKnown:{//自定义的类
                        if (info.cls && info.nsType == JSEncodeNSTypeUnKnown) {
                            NSObject *one = [info.cls new];
                            if ([one js_modelSetWithDictionary:value]) {
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,one);
                            }
                        }
                    }
                        break;
                    case JSEncodeNSTypeNSString:
                    case JSEncodeNSTypeNSMutableString:
                        if ([value isKindOfClass:[NSString class]]) {
                            if (info.nsType == JSEncodeNSTypeNSString) {
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,value);
                            }else{
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,((NSString *)value).mutableCopy);
                            }
                        }else if ([value isKindOfClass:[NSNumber class]]){
                            ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,info.nsType == JSEncodeNSTypeNSString ? ((NSNumber *)value).stringValue : ((NSNumber *)value).stringValue.mutableCopy);
                        }else if ([value isKindOfClass:[NSData class]]){
                            NSMutableString *string = [[NSMutableString alloc]initWithData:value encoding:NSUTF8StringEncoding];
                            ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,string);
                        }else if ([value isKindOfClass:[NSURL class]]){
                            ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,info.nsType == JSEncodeNSTypeNSString ? ((NSURL *)value).absoluteString : ((NSURL *)value).absoluteString.mutableCopy);
                        }else if ([value isKindOfClass:[NSAttributedString class]]){
                            ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,info.nsType == JSEncodeNSTypeNSString ? ((NSAttributedString *)value).string : ((NSAttributedString *)value).string.mutableCopy);
                        }
                        break;
                    case JSEncodeNSTypeNSValue:
                    case JSEncodeNSTypeNSDecimalNumber:
                    case JSEncodeNSTypeNSNumber:
                        if (info.nsType == JSEncodeNSTypeNSNumber) {
                            if ([value isKindOfClass:[NSNumber class]]) {
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,value);
                            }else if ([value isKindOfClass:[NSString class]]){
                                NSNumber *number = @([(NSString *)value intValue]);
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,number);
                            }
                        }else if (info.nsType == JSEncodeNSTypeNSDecimalNumber){
                            if ([value isKindOfClass:[NSNumber class]]) {
                                NSDecimalNumber *decNum = [NSDecimalNumber decimalNumberWithDecimal:[((NSNumber *)value) decimalValue]];
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,decNum);
                            }else if ([value isKindOfClass:[NSDecimalNumber class]]){
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,value);
                            }else if ([value isKindOfClass:[NSString class]]){
                                NSDecimalNumber *decNum = [NSDecimalNumber decimalNumberWithString:value];
                                NSDecimal dec = decNum.decimalValue;
                                if (dec._length == 0 && dec._isNegative) {
                                    decNum = nil; // NaN
                                }
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,decNum);
                            }
                        }else{//JSEncodeNSTypeNSValue
                            if ([value isKindOfClass:[NSValue class]]) {
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,value);
                            }
                        }
                        break;
                    case JSEncodeNSTypeNSDate:
                        if ([value isKindOfClass:[NSDate class]]) {
                            ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,value);
                        }else if ([value isKindOfClass:[NSString class]]){
                            NSDate *date = JSNSDateFromString(value);
                            ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,date);
                        }
                        break;
                    case JSEncodeNSTypeNSData:
                    case JSEncodeNSTypeNSMutableData:
                        
                        break;
                    case JSEncodeNSTypeNSArray:
                    case JSEncodeNSTypeNSMutableArray:
                        if (info.genericCls) {//自定义的类
                            NSMutableArray *array = [NSMutableArray array];
                            for (id temp in (NSArray *)value) {
                                NSObject *one = [info.genericCls new];
                                if ([one js_modelSetWithDictionary:temp]) {
                                    [array addObject:one];
                                }
                            }
                            ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,array);
                           
                        }else{
                            if ([value isKindOfClass:[NSArray class]]) {
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,info.nsType == JSEncodeNSTypeNSArray ? value : ((NSArray *)value).mutableCopy);
                            }
                        }
                        break;
                    case JSEncodeNSTypeNSURL:
                        
                        break;
                    case JSEncodeNSTypeNSDictionary:
                    case JSEncodeNSTypeNSMutableDictionary:
                        if (info.genericCls) {//自定义的类
                            NSObject *one = [info.genericCls new];
                            if ([one js_modelSetWithDictionary:value]) {
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,one);
                            }
                        }else{
                            if ([value isKindOfClass:[NSDictionary class]]) {
                                ((void (*)(id, SEL,id))(void *) objc_msgSend)((id)model, info.setter,info.nsType == JSEncodeNSTypeNSArray ? value : ((NSDictionary *)value).mutableCopy);
                            }
                        }
                        
                        break;
                    case JSEncodeNSTypeNSSet:
                    case JSEncodeNSTypeNSMutableSet:
                        
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
    }
}

@end
