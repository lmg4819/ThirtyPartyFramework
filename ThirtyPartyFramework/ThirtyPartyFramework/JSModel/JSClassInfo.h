//
//  JSClassInfo.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/8.
//  Copyright © 2019 we. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,JSEncodeType) {
    JSEncodeTypeUnKnown,
    JSEncodeTypeVoid,        ///< void
    JSEncodeTypeBool,        ///< bool
    JSEncodeTypeInt8,        ///< char / BOOL
    JSEncodeTypeUInt8,       ///< unsigned char
    JSEncodeTypeInt16,       ///< short
    JSEncodeTypeUInt16,      ///< unsigned char
    JSEncodeTypeInt32,       ///< int
    JSEncodeTypeUInt32,      ///< unsigned int
    JSEncodeTypeInt64,       ///< long long
    JSEncodeTypeUInt64,      ///< unsigned long long
    JSEncodeTypeFloat,       ///< float
    JSEncodeTypeDouble,      ///< double
    JSEncodeTypeLongDouble,  ///< long double
    JSEncodeTypeObject,      ///< id
    JSEncodeTypeClass,       ///< class
    JSEncodeTypeSEL,         ///< SEL
    JSEncodeTypeBlock,       ///< block
    JSEncodeTypeCString,     ///< char*
    JSEncodeTypeCArray,      ///< char[10]
    
};

typedef NS_ENUM(NSInteger,JSEncodeNSType) {
    JSEncodeNSTypeNSString,
    JSEncodeNSTypeNSMutableString,
    JSEncodeNSTypeNSNumber,
    JSEncodeNSTypeNSDecimalNumber,
    JSEncodeNSTypeNSDate,
    JSEncodeNSTypeNSValue,
    JSEncodeNSTypeNSData,
    JSEncodeNSTypeNSMutableData,
    JSEncodeNSTypeNSArray,
    JSEncodeNSTypeNSMutableArray,
    JSEncodeNSTypeNSURL,
    JSEncodeNSTypeNSDictionary,
    JSEncodeNSTypeNSMutableDictionary,
    JSEncodeNSTypeNSSet,
    JSEncodeNSTypeNSMutableSet,
    JSEncodeNSTypeUnKnown
};

@interface JSClassPropertyInfo : NSObject
@property(nonatomic,assign) objc_property_t  preperty;
@property(nonatomic,copy,readonly) NSString *name;
@property(nonatomic,copy) NSString *encodeType;
@property(nonatomic,assign) JSEncodeType type;
@property(nonatomic,assign) JSEncodeNSType  nsType;
@property(nonatomic,assign) Class  cls;
@property(nonatomic,assign) BOOL isCNumber;
@property(nonatomic,assign,readonly) SEL setter;
@property(nonatomic,assign,readonly) SEL getter;
@property(nonatomic,assign) Class  genericCls;

@end

@interface JSClassInfo : NSObject
@property(nonatomic,assign) Class cls;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) NSDictionary <NSString *,JSClassPropertyInfo *> *propertyInfos;


- (instancetype)initWithClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
