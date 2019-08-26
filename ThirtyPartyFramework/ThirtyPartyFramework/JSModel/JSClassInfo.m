//
//  JSClassInfo.m
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/8.
//  Copyright © 2019 we. All rights reserved.
//

#import "JSClassInfo.h"
#import <objc/message.h>


/**
 如果属性的数据类型为OC对象，获取该对象的具体NSType
 */
JSEncodeNSType JSEncodeGetNSTypeWithClass(Class cls){
    if (!cls) {
        return JSEncodeNSTypeUnKnown;
    }
    if ([cls isSubclassOfClass:[NSString class]]) return JSEncodeNSTypeNSString;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return JSEncodeNSTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSNumber class]]) return JSEncodeNSTypeNSNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return JSEncodeNSTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSDate class]]) return JSEncodeNSTypeNSDate;
    if ([cls isSubclassOfClass:[NSValue class]]) return JSEncodeNSTypeNSValue;
    if ([cls isSubclassOfClass:[NSData class]]) return JSEncodeNSTypeNSData;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return JSEncodeNSTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSArray class]]) return JSEncodeNSTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return JSEncodeNSTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSURL class]]) return JSEncodeNSTypeNSURL;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return JSEncodeNSTypeNSDictionary;    
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return JSEncodeNSTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSSet class]]) return JSEncodeNSTypeNSSet;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return JSEncodeNSTypeNSMutableSet;
    
    return JSEncodeNSTypeUnKnown;
}

/**
 根据属性的type判断属性是否为C语言的数据类型
 */
static BOOL JSEncodeTypeIsCNumber(JSEncodeType type)
{
    switch (type) {
        case JSEncodeTypeBool:
        case JSEncodeTypeInt8:
        case JSEncodeTypeUInt8:
        case JSEncodeTypeInt16:
        case JSEncodeTypeUInt16:
        case JSEncodeTypeInt32:
        case JSEncodeTypeUInt32:
        case JSEncodeTypeInt64:
        case JSEncodeTypeUInt64:
        case JSEncodeTypeFloat:
        case JSEncodeTypeDouble:
        case JSEncodeTypeLongDouble:
            return YES;
        default:
            return NO;
    }
}
/*
 根据property_attribute来获取属性的Type
 */
JSEncodeType JSEncodeGetType(const char *type){
    JSEncodeType encodeType = JSEncodeTypeUnKnown;
    size_t len = strlen(type);
    if (len == 0) {
        return JSEncodeTypeUnKnown;
    }
    switch (*type) {
        case 'v': return JSEncodeTypeVoid;
        case 'B': return JSEncodeTypeBool;
        case 'c': return JSEncodeTypeInt8;
        case 'C': return JSEncodeTypeUInt8;
        case 's': return JSEncodeTypeInt16;
        case 'S': return JSEncodeTypeUInt16;
        case 'i': return JSEncodeTypeInt32;
        case 'I': return JSEncodeTypeUInt32;
        case 'l': return JSEncodeTypeInt32;
        case 'L': return JSEncodeTypeUInt32;
        case 'q': return JSEncodeTypeInt64;
        case 'Q': return JSEncodeTypeUInt64;
        case 'f': return JSEncodeTypeFloat;
        case 'd': return JSEncodeTypeDouble;
        case 'D': return JSEncodeTypeLongDouble;
        case '#': return JSEncodeTypeClass;
        case ':': return JSEncodeTypeSEL;
        case '*': return JSEncodeTypeCString;
        case '[': return JSEncodeTypeCArray;
        case '@':{
            if (len == 2 && *(type + 1) == '?')
                return JSEncodeTypeBlock;
            else
                return JSEncodeTypeObject;
        }
            break;
            
        default:
            break;
    }
    return encodeType;
}

@interface JSClassPropertyInfo ()
@property(nonatomic,copy,readwrite) NSString *name;
@end

@implementation JSClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property
{
    self = [super init];
    if (self) {
        _preperty = property;
        const char *name = property_getName(property);
        _name = [NSString stringWithUTF8String:name];
        unsigned int outCount = 0;
        objc_property_attribute_t *property_attributes = property_copyAttributeList(property, &outCount);
        for (int i=0; i<outCount; i++) {
            objc_property_attribute_t property_attribute = property_attributes[i];
            NSString *attName = [ NSString stringWithUTF8String:property_attribute.name];
            _encodeType = [NSString stringWithUTF8String:property_attribute.value];
            
            if ([attName isEqualToString:@"T"]) {
                NSLog(@"%@----%@------%@",_name,attName,_encodeType);
                _type = JSEncodeGetType(property_attribute.value);
                _isCNumber = JSEncodeTypeIsCNumber(_type);
                if (_type == JSEncodeTypeObject && _encodeType.length) {
                    NSScanner *scanner = [NSScanner scannerWithString:_encodeType];
                    if (![scanner scanString:@"@\"" intoString:NULL]) continue;
                    
                    NSString *clsName = nil;
                    if ([scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&clsName]) {
                        if (clsName.length) _cls = objc_getClass(clsName.UTF8String);
                    }
                    _nsType = JSEncodeGetNSTypeWithClass(_cls);
                    _isCNumber = NO;
                }else{
                    _nsType = JSEncodeNSTypeUnKnown;
                    
                }
            }
        }
        //释放property_attributes对象
        if (property_attributes) {
            free(property_attributes);
            property_attributes = NULL;
        }
        //根据name，生成属性对应的set,get方法
        if (_name.length) {
            if (!_getter) {
                _getter = NSSelectorFromString(_name);
            }
            if (!_setter) {
                _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",[_name substringToIndex:1].uppercaseString,[_name substringFromIndex:1]]);
            }
        }
        
    }
    return self;
}

@end


@interface JSClassInfo ()

@end

@implementation JSClassInfo

- (instancetype)initWithClass:(Class)cls
{
    self = [super init];
    if (self) {
        _cls = cls;
        _name = NSStringFromClass(cls);
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        if (properties) {
            NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
            _propertyInfos = propertyInfos;
            for (unsigned int i = 0; i < propertyCount; i++) {
                objc_property_t property = properties[i];
                JSClassPropertyInfo *info = [[JSClassPropertyInfo alloc]initWithProperty:property];
                if (info.name) {
                    propertyInfos[info.name] = info;
                }
            }
            free(properties);
        }
    }
    return self;
}

@end

