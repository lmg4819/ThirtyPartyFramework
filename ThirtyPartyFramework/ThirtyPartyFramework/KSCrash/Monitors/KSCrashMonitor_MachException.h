//
//  KSCrashMonitor_MachException.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCrashMonitor_MachException_h
#define KSCrashMonitor_MachException_h

#ifdef __cplusplus
extern "C" {
#endif

#include "KSCrashMonitor.h"
#include <stdbool.h>

/** Access the Monitor API.*/
KSCrashMonitorAPI* kscm_machexception_getAPI(void);
    

#ifdef __cplusplus
}
#endif
    
#endif /* KSCrashMonitor_MachException_h */
