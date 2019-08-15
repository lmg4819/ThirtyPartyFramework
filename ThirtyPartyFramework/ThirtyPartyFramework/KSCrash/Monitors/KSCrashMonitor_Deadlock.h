//
//  KSCrashMonitor_Deadlock.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCrashMonitor_Deadlock_h
#define KSCrashMonitor_Deadlock_h

#ifdef __cplusplus
extern "C" {
#endif

#include "KSCrashMonitor.h"
#include <stdbool.h>

    void kscm_setDeadlockHandlerWatchdogInterval(double value);
    
    KSCrashMonitorAPI* kscm_deadlock_getAPI(void);
    
#ifdef __cplusplus
}
#endif
    
#endif /* KSCrashMonitor_Deadlock_h */
