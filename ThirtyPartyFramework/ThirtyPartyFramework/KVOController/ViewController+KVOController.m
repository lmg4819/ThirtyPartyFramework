//
//  ViewController+KVOController.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController+KVOController.h"
#import <KVOController.h>
#import "KVOModel.h"
#import <objc/runtime.h>

@interface ViewController ()
@property(nonatomic,strong) KVOModel *dataModel;

@end

@implementation ViewController (KVOController)

- (void)kvo_customInitMethod
{
    self.dataModel = [KVOModel new];
    self.dataModel.name = @"1111111";
    FBKVOController *kvoController = [[FBKVOController alloc]initWithObserver:self];
    [kvoController observe:self.dataModel keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (change) {
            NSLog(@"---%@---%@",object,change);
        }
    }];
    
    self.dataModel.name = @"22222222222";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataModel.name = @"3333333333333";
    });
    
}

#pragma mark - Set

- (void)setDataModel:(KVOModel *)dataModel
{
    objc_setAssociatedObject(self, @selector(dataModel), dataModel, OBJC_ASSOCIATION_RETAIN);
}

-(KVOModel *)dataModel
{
    return objc_getAssociatedObject(self, @selector(dataModel));
}

@end
