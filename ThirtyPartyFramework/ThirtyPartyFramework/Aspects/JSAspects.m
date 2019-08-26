//
//  JSAspects.m
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/14.
//  Copyright © 2019 we. All rights reserved.
//

#import "JSAspects.h"
#import <libkern/OSAtomic.h>
#import <objc/runtime.h>
#import <objc/message.h>


static NSString *const JSAspectsSubclassSuffix = @"_Aspects_";
static NSString *const JSAspectsMessagePrefix = @"aspects_";
static NSString *const AspectsForwardInvocationSelectorName = @"__aspects_forwardInvocation:";


@implementation NSObject (JSAspects)

#pragma mark - Public Aspects API

+ (id)aspect_hookSelector:(SEL)selector
              withOptions:(JSAspectOptions)options
               usingBlock:(id)block
                    error:(NSError *__autoreleasing *)error
{
    return aspect_add((id)self, selector, options, block, error);
}

- (id)aspect_hookSelector:(SEL)selector
              withOptions:(JSAspectOptions)options
               usingBlock:(id)block
                    error:(NSError *__autoreleasing *)error
{
    return aspect_add(self, selector, options, block, error);
}


#pragma mark - Private Helper

static id aspect_add(id self,SEL selector,JSAspectOptions options,id block,NSError **error){
    NSCParameterAssert(self);
    NSCParameterAssert(selector);
    NSCParameterAssert(block);
    __block JSAspectIdentifier *identifier = nil;
    aspect_performLocked(^{
        JSAspectContainer *aspectContainer = aspect_getContainerForObject(self, selector);
        identifier = [JSAspectIdentifier identifierWithSelector:selector object:self options:options block:block error:error];
        if (identifier) {
            [aspectContainer addAspect:identifier withOptions:options];
            
            aspect_prepareClassAndHookSelector(self, selector, error);
        }
    });
    return identifier;
}

static void aspect_performLocked(dispatch_block_t block){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    block();
    OSSpinLockUnlock(&aspect_lock);
#pragma clang diagnostic pop
    
}

static SEL aspect_aliasForSelector(SEL selector){
    NSCParameterAssert(selector);
    return NSSelectorFromString([JSAspectsMessagePrefix stringByAppendingFormat:@"_%@",NSStringFromSelector(selector)]);
}

#pragma mark - Aspect Container Management

static JSAspectContainer *aspect_getContainerForClass(Class klass,SEL selector){
    JSAspectContainer *classContainer = nil;
    do {
        classContainer = objc_getAssociatedObject(klass, selector);
        if (classContainer.hasAspects) break;
    } while ((klass = class_getSuperclass(klass)));
    return classContainer;
}

static JSAspectContainer *aspect_getContainerForObject(NSObject *self,SEL selector){
    NSCParameterAssert(self);
    SEL aliasSelector = aspect_aliasForSelector(selector);
    JSAspectContainer *aspectContainer = objc_getAssociatedObject(self, aliasSelector);
    if (!aspectContainer) {
        aspectContainer = [JSAspectContainer new];
        objc_setAssociatedObject(self, aliasSelector, aspectContainer, OBJC_ASSOCIATION_RETAIN);
    }
    return aspectContainer;
}

#pragma mark - Class + Selector Preparation

static BOOL aspect_isMsgForwardIMP(IMP impl){
    return impl == _objc_msgForward
#if !defined(__arm64__)
    || impl == (IMP)_objc_msgForward_stret
#endif
    ;
}

static IMP aspect_getMsgForwardIMP(NSObject *self,SEL selector){
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    
    Method method = class_getInstanceMethod(self.class, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

static void aspect_prepareClassAndHookSelector(NSObject *self,SEL selector,NSError **error){
    NSCParameterAssert(selector);
    //获取要进行Method Swizzle的类
    Class klass = aspect_hookClass(self, error);
    
    Method targetMethod = class_getInstanceMethod(klass, selector);
    IMP targetMethodIMP = method_getImplementation(targetMethod);
    if (!aspect_isMsgForwardIMP(targetMethodIMP)) {
        const char *typeEncoding = method_getTypeEncoding(targetMethod);
        SEL aliasSelector = aspect_aliasForSelector(selector);
        if (![klass instancesRespondToSelector:aliasSelector]) {
            __unused BOOL addedAlias = class_addMethod(klass, aliasSelector, method_getImplementation(targetMethod), typeEncoding);
        }
        class_replaceMethod(klass, selector, aspect_getMsgForwardIMP(self, selector), typeEncoding);
    }
}

#pragma mark - Hook Class

static Class aspect_hookClass(NSObject *self,NSError **error){
    NSCParameterAssert(self);
    Class statedClass = self.class;
    Class baseClass = object_getClass(self);//返回的是isa指向的对象
    NSString *className = NSStringFromClass(baseClass);
    
    // 如果该类的后缀是 AspectsSubclassSuffix ，说明对应 instancel 已经生成了子类，并且 instance 的 isa也指向了子类，可以直接返回。
    if ([className hasSuffix:JSAspectsSubclassSuffix]) {
        return baseClass;
        //如果是元类，判断是否已经 hook 过 forwardInvocation 方法了，如果 hook 过，就直接返回，否则 hook 后在返回。
    }else if (class_isMetaClass(baseClass)) {
        return aspect_swizzleClassInPlace((Class)self);
        //如果 self.class != object_getClass(self) ，所以对象的 isa 已经改变了(KVO)，对 object_getClass(self) 的 forwardInvocation 进行 hook 。
    }else if (statedClass != baseClass){
        return aspect_swizzleClassInPlace(baseClass);
    }
    
    const char *subclassName = [className stringByAppendingString:JSAspectsSubclassSuffix].UTF8String;
    Class subclass = objc_getClass(subclassName);
    if (subclass == nil) {
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);
        
        aspect_swizzleForwardInvocation(subclass);
        //修改了subClass以及其meta Class的class方法，使他返回当前对象的class，隐藏对外的class，类似KVO
        aspect_hookedGetClass(subclass, statedClass);
        aspect_hookedGetClass(object_getClass(subclass), statedClass);
        objc_registerClassPair(subclass);
    }
    //将当前对象 isa 指针指向了 subclass
    object_setClass(self, subclass);
    return subclass;
}

static void aspect_swizzleForwardInvocation(Class class){
    NSCParameterAssert(class);
    /*
1.如果class没有实现@selector(forwardInvocation:)方法，就会增加这个方法，就像class_addMethod一样，但是IMP指向会被替换成新的实现，返回的originalImplementation为nil
2.如果class实现了@selector(forwardInvocation:)方法，会替换IMP指向新的实现，返回的originalImplementation为原来的方法实现，此时会再增加一个新方法，新方法的
     IMP指向为originalImplementation
     */
    IMP originalImplementation = class_replaceMethod(class, @selector(forwardInvocation:), (IMP)__ASPECTS_ARE_BEING_CALLED__,"v@:@");
    if (originalImplementation) {
        class_addMethod(class, NSSelectorFromString(AspectsForwardInvocationSelectorName), originalImplementation, "v@:@");
    }
}

static void aspect_hookedGetClass(Class class,Class statedClass){
    NSCParameterAssert(class);
    NSCParameterAssert(statedClass);
    Method method = class_getInstanceMethod(class, @selector(class));
    IMP newIMP = imp_implementationWithBlock(^(id self){
        return statedClass;
    });
    class_replaceMethod(class, @selector(class), newIMP, method_getTypeEncoding(method));
}

#pragma mark - Swizzle Class In Place

static void _aspect_modifySwizzledClasses(void(^block)(NSMutableSet *swizzledClasses)){
    static NSMutableSet *swizzledClasses;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [NSMutableSet new];
    });
    @synchronized (swizzledClasses) {
        block(swizzledClasses);
    }
}

static Class aspect_swizzleClassInPlace(Class klass){
    NSCParameterAssert(klass);
    NSString *className = NSStringFromClass(klass);
    _aspect_modifySwizzledClasses(^(NSMutableSet *swizzledClasses) {
        if (![swizzledClasses containsObject:className]) {
            aspect_swizzleForwardInvocation(klass);
            [swizzledClasses addObject:className];
        }
    });
    return klass;
}

#pragma mark - Aspect Invoke Point

static void aspect_invoke(NSArray *aspects,JSAspectInfo *info){
    for (JSAspectIdentifier *aspect in aspects) {
        [aspect invokeWithInfo:info];
    }
}

static void __ASPECTS_ARE_BEING_CALLED__(__unsafe_unretained NSObject *self,SEL selector,NSInvocation *invocation){
    NSCParameterAssert(self);
    NSCParameterAssert(invocation);

    SEL originalSelector = invocation.selector;
    SEL aliasSelector = aspect_aliasForSelector(originalSelector);
    invocation.selector = aliasSelector;
    //拿出对象关联的Aspects
    JSAspectContainer *objectContainer = objc_getAssociatedObject(self, aliasSelector);
    //拿出类关联的Aspects
    JSAspectContainer *classContainer = aspect_getContainerForClass(object_getClass(self), aliasSelector);
    JSAspectInfo *info = [[JSAspectInfo alloc]initWithInstance:self invocation:invocation];
    
    //before hooks block方法调用
    aspect_invoke(classContainer.beforeAspects, info);
    aspect_invoke(objectContainer.beforeAspects, info);
    
    //Insteda hooks block方法调用
    BOOL respondsToAlias = YES;
    if (objectContainer.insteadAspects.count || classContainer.insteadAspects.count) {
        aspect_invoke(classContainer.insteadAspects, info);
        aspect_invoke(objectContainer.insteadAspects, info);
    }else{//如果instead Aspects为nil，则调用原方法的IMP
        Class klass = object_getClass(invocation.target);
        do {
            if ((respondsToAlias = [klass instancesRespondToSelector:aliasSelector])) {
                [invocation invoke];
                break;
            }
        } while (!respondsToAlias && (klass = class_getSuperclass(klass)));
    }
    
    //after hooks block方法调用
    aspect_invoke(classContainer.afterAspects, info);
    aspect_invoke(objectContainer.afterAspects, info);
    
    //if no hooks are installed,call original implementation(usually to throw an exception)
    if (!respondsToAlias) {
        invocation.selector = originalSelector;
        SEL originalForwardInvocationSEL = NSSelectorFromString(AspectsForwardInvocationSelectorName);
        if ([self respondsToSelector:originalForwardInvocationSEL]) {
            ((void( *)(id, SEL, NSInvocation *))objc_msgSend)(self, originalForwardInvocationSEL, invocation);
        }else{
            [self doesNotRecognizeSelector:invocation.selector];
        }
    }
}



@end


