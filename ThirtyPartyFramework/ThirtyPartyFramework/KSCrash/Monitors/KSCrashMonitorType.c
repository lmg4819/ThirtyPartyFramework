//
//  KSCrashMonitorType.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSCrashMonitorType.h"

#include <stdlib.h>


static const struct{
    const KSCrashMonitorType type;
    const char* const name;
} g_monitorTypes[] =
{
#define MONITORTYPE(NAME) {NAME,#NAME}
    MONITORTYPE(KSCrashMonitorTypeMachException),
    MONITORTYPE(KSCrashMonitorTypeSignal),
    MONITORTYPE(KSCrashMonitorTypeCPPException),
    MONITORTYPE(KSCrashMonitorTypeNSException),
    MONITORTYPE(KSCrashMonitorTypeMainThreadDeadlock),
    MONITORTYPE(KSCrashMonitorTypeUserReported),
    MONITORTYPE(KSCrashMonitorTypeSystem),
    MONITORTYPE(KSCrashMonitorTypeApplicationState),
    MONITORTYPE(KSCrashMonitorTypeZombie),
};

static const int g_monitorTypesCount = sizeof(g_monitorTypes) / sizeof(*g_monitorTypes);


const char* kscrashmonitortype_name(const KSCrashMonitorType monitorType)
{
    for (int i=0; i<g_monitorTypesCount; i++) {
        if (g_monitorTypes[i].type == monitorType) {
            return g_monitorTypes[i].name;
        }
    }
    return NULL;
}
