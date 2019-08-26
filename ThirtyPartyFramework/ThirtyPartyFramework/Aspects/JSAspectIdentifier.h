//
//  JSAspectIdentifier.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/15.
//  Copyright © 2019 we. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,JSAspectOptions) {
    JSAspectPositionAfter   = 0,
    JSAspectPositionInstead = 1,
    JSAspectPositionBefore  = 2,
};


@protocol JSAspectInfo <NSObject>

- (id)instance;

- (NSInvocation *)originalInvocation;

@end


@interface JSAspectInfo : NSObject <JSAspectInfo>
- (id)initWithInstance:(__unsafe_unretained id)instance invocation:(NSInvocation *)invocation;
@property (nonatomic,readonly,unsafe_unretained) id instance;
@property (nonatomic,readonly,strong) NSInvocation *originalInvocation;
@end


@interface JSAspectIdentifier : NSObject
+ (id)identifierWithSelector:(SEL)selector object:(id)object options:(JSAspectOptions)options block:(id)block error:(NSError **)error;

/**
 使用Runtime调用回调的block
 */
- (BOOL)invokeWithInfo:(id<JSAspectInfo>)info;
@property(nonatomic,assign) SEL selector;
@property(nonatomic,strong) id block;
@property(nonatomic,strong) NSMethodSignature *blockSignature;
@property(nonatomic,weak) id object;
@property(nonatomic,assign) JSAspectOptions options;
@end

@interface JSAspectContainer : NSObject
- (void)addAspect:(JSAspectIdentifier *)aspect withOptions:(JSAspectOptions)injectPosition;
- (BOOL)hasAspects;
@property(nonatomic,copy) NSArray *beforeAspects;
@property(nonatomic,copy) NSArray *insteadAspects;
@property(nonatomic,copy) NSArray *afterAspects;
@end

NS_ASSUME_NONNULL_END
