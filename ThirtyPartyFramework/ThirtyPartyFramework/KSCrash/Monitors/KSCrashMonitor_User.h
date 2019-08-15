//
//  KSCrashMonitor_User.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCrashMonitor_User_h
#define KSCrashMonitor_User_h

#ifdef __cplusplus
extern "C" {
#endif

#include "KSCrashMonitor.h"
    
#include <stdbool.h>
    
    void kscm_reportUserException(const char* name,
                                  const char* reason,
                                  const char* language,
                                  const char* lineOfCode,
                                  const char* stackTrace,
                                  bool logAllThreads,
                                  bool terminateProgram);

    KSCrashMonitorAPI* kscm_user_getAPI(void);
#ifdef __cplusplus
}
#endif
    
    

#endif /* KSCrashMonitor_User_h */
