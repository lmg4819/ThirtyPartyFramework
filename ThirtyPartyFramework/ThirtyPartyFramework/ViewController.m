//
//  ViewController.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+OHHTTPStub.h"
#import "ViewController+TTGTagCollectionView.h"
#import "ViewController+HCSStarRatingView.h"
#import "ViewController+VTMagic.h"
#import "ViewController+KVOController.h"
#import "ViewController+JSModel.h"
#import <KVOController.h>
#import "KVOModel.h"
#import <Aspects.h>


@interface ViewController ()
@property(nonatomic,strong) KVOModel *dataModel;
@end


@interface NSObject (Sark)
+ (void)foo;
@end

@implementation NSObject (Sark)

- (void)foo{
    NSLog(@"IMP: -[NSObject (Sark) foo]");
}

@end

@interface Sark : NSObject
@property(nonatomic,copy) NSString *name;
@end

@implementation Sark
- (void)speak
{
    NSLog(@"my name's %@",self.name);
}

@end


@implementation ViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"111111111111111");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    [self oh_customInitMethod];
//    [self ttg_customInitMethod];
//    [self hcs_customInitMethod];
//    [self vt_customInitMethod];
//    [self kvo_customInitMethod];
    [self js_customInitMethod];
    
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
            if (info) {
                NSLog(@"========%@==========",info.instance);
            }
    } error:nil];
    
//    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
//        if (info) {
//            NSLog(@"----------%@---------",info.instance);
//        }
//    } error:nil];
    
//    [self aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
//        if (info) {
//            NSLog(@"========%@==========",info.instance);
//        }
//    } error:nil];
    
    
    
    
    [super viewDidLoad];
    
//    NSLog(@"ViewController = %@ , 地址 = %p", self, &self);
//
//    NSString *myName = @"halfrost";
//
//    id cls = [Sark class];
//    NSLog(@"Sark class = %@ 地址 = %p", cls, &cls);
//
//    void *obj = &cls;
//    NSLog(@"Void *obj = %@ 地址 = %p", obj,&obj);
//
//    [(__bridge id)obj speak];

    
//    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];//YES
//    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];//NO
//    BOOL res3 = [(id)[Sark class] isKindOfClass:[NSObject class]];//YES
//    BOOL res4 = [(id)[Sark class] isMemberOfClass:[NSObject class]];//NO
//
    [NSObject foo];
    [[NSObject new] foo];
    
}
/*
 NSObject--isa--NSObject Meta Class---superClass--->NSObject---superClass--nil
 Sark---isa--Sark Meta Class--superClass----NSObject Meta Class---superClass--->NSObject---superClass--nil
 */

/*
 NSObject--isa--NSObject Meta Class---superClass--->NSObject
 NSObject new ---isa---NSObject
 
 */

@end
