//
//  KSCrashMonitor_NSException.m
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#import "KSCrashMonitor_NSException.h"
#include "KSCrashMonitorContext.h"
#import <Foundation/Foundation.h>
#include "KSID.h"

static volatile bool g_isEnabled = 0;

static KSCrash_MonitorContext g_monitorContext;

static NSUncaughtExceptionHandler* g_previousUncaughtExceptionHandler;

static void handleException(NSException *exception,BOOL currentSnapshotUserReported){
    if (g_isEnabled) {
        kscm_notifyFatalExceptionCaptured(false);
        
        NSArray *addresses = [exception callStackReturnAddresses];
        NSUInteger numFrames = addresses.count;
        uintptr_t *callstack = malloc(numFrames * sizeof(*callstack));
        for (int i=0; i<numFrames; i++) {
            callstack[i] = (uintptr_t)[addresses[i] unsignedLongLongValue];
        }
        
        char eventID[37];
        ksid_generate(eventID);
//        KSMC_NEW_CONTEXT(machineContext);
//        ksmc_getContextForThread(ksthread_self(), machineContext, true);
//        KSStackCursor cursor;
//        kssc_initWithBacktrace(&cursor, callstack, (int)numFrames, 0);
        
        KSCrash_MonitorContext *crashContext = &g_monitorContext;
        memset(crashContext, 0, sizeof(*crashContext));
        crashContext->crashType = KSCrashMonitorTypeNSException;
        crashContext->eventID = eventID;
//        crashContext->offendingMachineContext = machineContext;
        crashContext->registersAreValid = false;
        crashContext->NSException.name = [[exception name] UTF8String];
        crashContext->NSException.userInfo = [[NSString stringWithFormat:@"%@",exception.userInfo] UTF8String];
        crashContext->exceptionName = crashContext->NSException.name;
        crashContext->crashReason = [[exception reason] UTF8String];
//        crashContext->stackCursor = &cursor;
        crashContext->currentSnapshotUserReported = currentSnapshotUserReported;
        
//        KSLOG_DEBUG(@"Calling main crash handler.");
        
    }
}


static void handleCurrentSnapshotUserReportedException(NSException *exception){
    handleException(exception, true);
}

static void handleUncaughtException(NSException *exception){
    handleException(exception, false);
}

#pragma mark - API

static void setEnabled(bool isEnabled)
{
    if (isEnabled != g_isEnabled) {
        g_isEnabled = isEnabled;
        if (isEnabled) {
            g_previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
            NSSetUncaughtExceptionHandler(&handleUncaughtException);
//            KSCrash.sharedInstance.uncaughtExceptionHandler = &handleUncaughtException;
//            KSCrash.sharedInstance.currentSnapshotUserReportedExceptionHandler = &handleCurrentSnapshotUserReportedException;
        }else{
            NSSetUncaughtExceptionHandler(g_previousUncaughtExceptionHandler);
        }
    }
}

static bool isEnabled()
{
    return g_isEnabled;
}

KSCrashMonitorAPI *kscm_nsexception_getAPI(){
    static KSCrashMonitorAPI api =
    {
        .setEnabled = setEnabled,
        .isEnabled = isEnabled
    };
    return &api;
}
