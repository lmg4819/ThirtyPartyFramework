//
//  KSCrashMonitor_Zombie.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCrashMonitor_Zombie_h
#define KSCrashMonitor_Zombie_h


#ifdef __cplusplus
extern "C" {
#endif


#include "KSCrashMonitor.h"
#include <stdbool.h>
    
    
    
    const char* kszombie_className(const void* object);
    
    KSCrashMonitorAPI* kscm_zombie_getAPI(void);
    
#ifdef __cplusplus
}
#endif
    

#endif /* KSCrashMonitor_Zombie_h */
