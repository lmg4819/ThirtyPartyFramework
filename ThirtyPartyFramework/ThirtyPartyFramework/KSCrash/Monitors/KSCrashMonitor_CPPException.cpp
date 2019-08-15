//
//  KSCrashMonitor_CPPException.cpp
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSCrashMonitor_CPPException.h"


extern "C" KSCrashMonitorAPI* kscm_cppexception_getAPI()
{
    static KSCrashMonitorAPI api =
    {
        
    };
    return &api;
}

