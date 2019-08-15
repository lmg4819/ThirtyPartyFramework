//
//  JSAspects.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/14.
//  Copyright © 2019 we. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSAspectIdentifier.h"



@interface NSObject (JSAspects)

+ (id)aspect_hookSelector:(SEL)selector
              withOptions:(JSAspectOptions)options
               usingBlock:(id)block
                    error:(NSError **)error;

- (id)aspect_hookSelector:(SEL)selector
              withOptions:(JSAspectOptions)options
               usingBlock:(id)block
                    espectrror:(NSError **)error;

@end

/*
 先将self 和 selector options block error
 1.根据selector生成aliasSelector   for example  viewWillAppear:------->aspects_viewWillAppear
 2.根据aliasSelector生成对应的JSAspectContainer
 3.根据selector和selector options block error生成JSAspectIdentifier，放入对应的aspectsArray里面
 4.获取到需要进行Method Swizzle的类，具体如下：
 baseClass = object_getClass(self);  //self的isa指针指向的类
    4.1 如果baseClass的类名后缀是_Aspects_，说明self已经生成了子类，并且self的isa指针指向了子类，直接返回子类类名即可
    4.2 如果baseClass是元类，判断self是否已经hook过了forwardInvocation：方法，如果hook过了就返回，没有的话就进行hook
    4.3 如果baseClass ！= self.class 说明对象的isa指针已经改变了（KVO），对baseClass进行是否hook过了forwardInvocation：方法进行判断，
        如果hook过了就返回，没有的话就进行hook
    4.4 如果以上情况都不是，说明是自定义的类，就需要实例化一个子类subClass(类名XXX_Aspects_),对subClass的forwardInvocation：方法进行Hook，修改subClass和subClass的isa指针的类的class方法，使其返回self.class,对外隐藏内部实现。类似KVO，修改self的isa指针指向subClass。
  5. 获取到selector的Method和IMP，判断IMP是否是消息转发(_objc_msgForward)，如果不是的话
     5.1 判断class的实例是否响应sliasSelector方法，如果不响应的话，增加sliasSelector方法，对应的是selector的IMP
     5.2 替换selector方法的实现为消息转发(_objc_msgForward)
 
  最关键的部分是hook过的forwardInvocation：方法的实现aspect_swizzleForwardInvocation：
 
 
 
 */
