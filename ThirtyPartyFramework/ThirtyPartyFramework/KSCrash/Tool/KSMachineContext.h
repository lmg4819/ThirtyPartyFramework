//
//  KSMachineContext.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/2.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSMachineContext_h
#define KSMachineContext_h


#ifdef __cplusplus
extern "C" {
#endif

#include "KSThread.h"
#include <stdbool.h>
    
    
    /**
      Suspend the runtime environment.
     */
    void ksmc_suspendEnvironment(void);
    
    /**
     Resume the runtime environment.
     */
    void ksmc_resumeEnvironment(void);
    
    
/**
 Create a new machine context on the stack.
 */
#define KSMC_NEW_CONTEXT(NAME) \
char ksmc_##NAME##_storage[ksmc_contextSize()]; \
struct KSMachineContext* NAME = (struct KSMachineContext*)ksmc_##NAME##_storage
    
    
    struct KSMachineContext;
    
    int ksmc_contextSize(void);
    
    bool ksmc_getContextForThread(KSThread thread,struct KSMachineContext* destinationContext,bool isCrashedContext);
    
    bool kscm_getksmc_getContextForSignal(void* signalUserContext,struct KSMachineContext* destinationContext);
    
    KSThread ksmc_getThreadFromContext(const struct KSMachineContext* const context);
    
    int ksmc_getThreadCount(const struct KSMachineContext* const context);
    
    KSThread ksmc_getThreadAtIndex(const struct KSMachineContext* const context, int index);
    
    int ksmc_indexOfThread(const struct KSMachineContext* const context, KSThread thread);
    
    bool ksmc_isCrashedContext(const struct KSMachineContext* const context);
    
    bool ksmc_canHaveCPUState(const struct KSMachineContext* const context);
    
    bool ksmc_hasValidExceptionRegisters(const struct KSMachineContext* const context);
    
    void ksmc_addReservedThread(KSThread thread);
    
#ifdef __cplusplus
}
#endif

#endif /* KSMachineContext_h */
