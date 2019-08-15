//
//  KSCPU.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/5.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSCPU.h"
#include "KSSystemCapabilities.h"

#include <mach/mach.h>
#include <mach-o/arch.h>

//#define KSLogger_LocalLevel TRACE
#include "KSLogger.h"


const char* kscpu_currentArch(void)
{
    const NXArchInfo* archInfo = NXGetLocalArchInfo();
    return archInfo == NULL ? NULL : archInfo->name;
}

#if KSCRASH_HAS_THREADS_API
bool kscpu_i_fillState(const thread_t thread,
                       const thread_state_t state,
                       const thread_state_flavor_t flavor,
                       const mach_msg_type_number_t stateCount)
{
    KSLOG_TRACE("Filling thread state with flavor %x.", flavor);
    mach_msg_type_number_t stateCountBuff = stateCount;
    kern_return_t kr;
    
    kr = thread_get_state(thread, flavor, state, &stateCountBuff);
    if(kr != KERN_SUCCESS)
    {
        KSLOG_ERROR("thread_get_state: %s", mach_error_string(kr));
        return false;
    }
    return true;
}
#else
bool kscpu_i_fillState(__unused const thread_t thread,
                       __unused const thread_state_t state,
                       __unused const thread_state_flavor_t flavor,
                       __unused const mach_msg_type_number_t stateCount)
{
    return false;
}

#endif

