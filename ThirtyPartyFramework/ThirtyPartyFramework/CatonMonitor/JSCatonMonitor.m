//
//  JSCatonMonitor.m
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/22.
//  Copyright © 2019 we. All rights reserved.
//

#import "JSCatonMonitor.h"
#import <CrashReporter/CrashReporter.h>


@interface JSCatonMonitor ()
{
    int timeOutCount;
    CFRunLoopObserverRef runLoopObserver;
    @public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}
@end


@implementation JSCatonMonitor

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer,CFRunLoopActivity activity,void *info){
    JSCatonMonitor *monitor = (__bridge JSCatonMonitor *)info;
    monitor->activity = activity;
    
    dispatch_semaphore_t semaphore = monitor->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)start
{
    if (runLoopObserver) {
        return;
    }
    semaphore = dispatch_semaphore_create(0);
    
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0) {//返回0，表示正常，返回非0，表示超时
                if (!self->runLoopObserver) {
                    self->timeOutCount = 0;
                    self->semaphore = 0;
                    self->activity = 0;
                    return ;
                }
                if (self->activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting) {
                    //假定连续5次超时50ms认为卡顿(当然也包含了单次超时250ms)
                    if ((++self->timeOutCount) < 5)
                        continue;
                        PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                                           symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
                        PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
                        
                        NSData *data = [crashReporter generateLiveReport];
                        PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
                        NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                                                  withTextFormat:PLCrashReportTextFormatiOS];
                        NSLog(@"------------\n%@\n------------", report);
                    
                }
            }
            self->timeOutCount = 0;
        }
    });
    
}

- (void)stop
{
    if (!runLoopObserver) {
        return;
    }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}

@end
