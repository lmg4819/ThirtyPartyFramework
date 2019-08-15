//
//  KSCrashMonitor_Zombie.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSCrashMonitor_Zombie.h"




KSCrashMonitorAPI* kscm_zombie_getAPI()
{
    static KSCrashMonitorAPI api =
    {
        
    };
    return &api;
}
