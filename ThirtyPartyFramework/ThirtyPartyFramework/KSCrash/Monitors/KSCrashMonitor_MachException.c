//
//  KSCrashMonitor_MachException.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSCrashMonitor_MachException.h"


KSCrashMonitorAPI* kscm_machexception_getAPI()
{
    static KSCrashMonitorAPI api =
    {
#if KSCRASH_HAS_MACH
        
#endif
    };
    return &api;
}
