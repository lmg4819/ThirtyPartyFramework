//
//  KSDebug.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSDebug.h"

#include "KSLogger.h"

#include <errno.h>
#include <string.h>
#include <sys/sysctl.h>
#include <unistd.h>


bool ksdebug_isBeingTraced(void)
{
    struct kinfo_proc procInfo;
    size_t structSize = sizeof(procInfo);
    int mib[] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()};
    
    if(sysctl(mib, sizeof(mib)/sizeof(*mib), &procInfo, &structSize, NULL, 0) != 0)
    {
        KSLOG_ERROR("sysctl: %s", strerror(errno));
        return false;
    }
    
    return (procInfo.kp_proc.p_flag & P_TRACED) != 0;
}
