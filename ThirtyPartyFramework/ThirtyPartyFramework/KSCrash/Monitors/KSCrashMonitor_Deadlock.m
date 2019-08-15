//
//  KSCrashMonitor_Deadlock.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSCrashMonitor_Deadlock.h"
#include "KSCrashMonitorContext.h"
#include "KSID.h"
#include "KSThread.h"
#import <Foundation/Foundation.h>

//#define KSLogger_LocalLevel TRACE
#import "KSLogger.h"

#define kIdleInterval 5.0f

@class KSCrashDeadlockMonitor;

#pragma mark - Globals

static volatile bool g_isEnabled = false;
static KSCrash_MonitorContext g_monitorContext;

/** Thread which monitors other threads. */
static KSCrashDeadlockMonitor* g_monitor;

static KSThread g_mainQueueThread;

/** Interval between watchdog pulses. */
static NSTimeInterval g_watchdogInterval = 0;

#pragma mark - X

@interface KSCrashDeadlockMonitor : NSObject
@property(nonatomic,strong) NSThread *monitorThread;
@property(atomic,assign) BOOL awaitingResponse;
@end

@implementation KSCrashDeadlockMonitor

- (instancetype)init
{
    if (self = [super init]) {
        self.monitorThread = [[NSThread alloc]initWithTarget:self selector:@selector(runMonitor) object:nil];
        self.monitorThread.name = @"KSCrash Deadlock Detection Thread";
        [self.monitorThread start];
    }
    return self;
}

- (void)cancel
{
    [self.monitorThread cancel];
}

- (void)handleDeadlock
{
    
}

- (void)watchdogPulse
{
    __block id blockSelf = self;
    self.awaitingResponse = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [blockSelf watchdogAnswer];
    });
}

- (void)watchdogAnswer
{
    self.awaitingResponse = NO;
}

- (void)runMonitor
{
    BOOL cancelled = NO;
    do {
        //Only do a watchdog check if the watchdog interval is > 0.
        //If the interval is <= 0, just idle until the user changes it.
        @autoreleasepool {
            NSTimeInterval sleepInterval = g_watchdogInterval;
            BOOL runWatchdogCheck = sleepInterval > 0;
            if (!runWatchdogCheck) {
                sleepInterval = kIdleInterval;
            }
            [NSThread sleepForTimeInterval:sleepInterval];
            cancelled = self.monitorThread.isCancelled;
            if (!cancelled && runWatchdogCheck) {
                if (self.awaitingResponse) {
                    [self handleDeadlock];
                }else{
                    [self watchdogPulse];
                }
            }
        }
    } while (!cancelled);
}

@end

KSCrashMonitorAPI* kscm_deadlock_getAPI()
{
    static KSCrashMonitorAPI api =
    {
        
    };
    return &api;
}
