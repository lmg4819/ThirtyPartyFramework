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
                    error:(NSError **)error;

@end

/*
 先将self 和 selector options block error参数
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
 
  最关键的部分是hook过的forwardInvocation：方法的实现aspect_swizzleForwardInvocation
 aspect_swizzleForwardInvocation里面的主要代码功能：
 1. 如果class没有实现@selector(forwardInvocation:)方法，就会增加这个方法，就像class_addMethod一样，但是IMP指向会被替换成新的实现，返回的originalImplementation为nil
 2. 如果class实现了@selector(forwardInvocation:)方法，会替换IMP指向新的实现，返回的originalImplementation为原来的方法实现，此时会再增加一个新方法，新方法的
     IMP指向为originalImplementation
 
 最核心的功能代码其实都在__ASPECTS_ARE_BEING_CALLED__这个方法里面，这个方法是整个类的最核心功能的代码
 1. 取出aliasSelector对应的objectContainer和classContainer对象
 2. 执行类和对象Container的beforeAspects方法
 3. 如果有的话执行类和对象Container的InsteadAspects方法，否则的话执行target的aliasSelector方法(之前添加了aliasSelector方法，该方法的实现对应selector的IMP)
 4. 执行类和对象Container的afterAspects方法
 5. 如果之前第三步的两种路径都未执行的话，如果target响应“__aspects_forwardInvocation:”方法的话，执行__aspects_forwardInvocation(如果target实现了forwardInvocation:方法的话，会增加__aspects_forwardInvocation:方法，此方法对应的是forwardInvocation:的IMP)，如果不相应的话，会走doesNotRecognizeSelector方法，抛出异常
 
 
 */
