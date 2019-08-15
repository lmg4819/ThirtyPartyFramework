//
//  KSMachineContext_Apple.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/5.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSMachineContext_Apple_h
#define KSMachineContext_Apple_h


#ifdef __cplusplus
extern "C" {
#endif
    
#include <mach/mach_types.h>
#include <stdbool.h>
#include <sys/ucontext.h>
    
#ifdef __arm64__
#define STRUCT_MCONTEXT_L _STRUCT_MCONTEXT64
#else
#define STRUCT_MCONTEXT_L _STRUCT_MCONTEXT
#endif
    
    
    typedef struct KSMachineContext{
        thread_t thisThread;
        thread_t allThreads[100];
        int threadCount;
        bool isCrashedContext;
        bool isCurrentThread;
        bool isStackOverflow;
        bool isSignalContext;
        STRUCT_MCONTEXT_L machineContext;
    }KSMachineContext;
    
    
#ifdef __cplusplus
}
#endif

#endif /* KSMachineContext_Apple_h */
