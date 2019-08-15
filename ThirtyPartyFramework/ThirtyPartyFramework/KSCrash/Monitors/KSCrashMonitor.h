//
//  KSCrashMonitor.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCrashMonitor_h
#define KSCrashMonitor_h

//限制下面的代码按照C语言的方式编译，而不是按照C++的方式
#ifdef __cplusplus
extern "C" {
#endif

#include "KSCrashMonitorType.h"
#include "KSThread.h"
#include <stdbool.h>

    struct KSCrash_MonitorContext;
    
    
#pragma mark - External API -
    
    void kscm_setActiveMonitors(KSCrashMonitorType monitorTypes);
    
    KSCrashMonitorType kscm_getActiveMonitors(void);
    
    void kscm_setEventCallback(void (*onEvent)(struct KSCrash_MonitorContext* monitorContext));
    
    
#pragma mark - Internal API -
    
    typedef struct
    {
        void(*setEnabled)(bool isEnabled);
        bool (*isEnabled)(void);
        void (*addContextualInfoToEvent)(struct KSCrash_MonitorContext* eventContext);
    }KSCrashMonitorAPI;

    bool kscm_notifyFatalExceptionCaptured(bool isAsyncSafeEnvironment);
    
    void kscm_handleException(struct KSCrash_MonitorContext* context);
    
    
#ifdef __cplusplus
}
#endif

#endif /* KSCrashMonitor_h */
