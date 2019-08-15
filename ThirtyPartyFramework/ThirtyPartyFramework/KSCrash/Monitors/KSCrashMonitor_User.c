//
//  KSCrashMonitor_User.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSCrashMonitor_User.h"



KSCrashMonitorAPI* kscm_user_getAPI()
{
    static KSCrashMonitorAPI api =
    {
        
    };
    return &api;
}
