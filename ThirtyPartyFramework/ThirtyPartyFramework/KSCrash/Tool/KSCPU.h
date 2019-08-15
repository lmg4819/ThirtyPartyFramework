//
//  KSCPU.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/5.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCPU_h
#define KSCPU_h

#ifdef __cplusplus
extern "C" {
#endif

#include "KSMachineContext.h"
    
#include <stdbool.h>
#include <stdint.h>
    
    /**
     Get the current CPU architecture.
     */
    const char* kscpu_currentArch(void);
    
    uintptr_t kscpu_framePointer(const struct KSMachineContext* const context);
    
    uintptr_t kscpu_stackPointer(const struct KSMachineContext* const context);
    
    uintptr_t kscpu_instructionAddress(const struct KSMachineContext* const context);
    
    uintptr_t kscpu_linkRegister(const struct KSMachineContext* const context);
    
    uintptr_t kscpu_faultAddress(const struct KSMachineContext* const context);
    
    int kscpu_numRegisters(void);
    
    const char* kscpu_registerName(int regNumber);
    
    uint64_t kscpu_registerValue(const struct KSMachineContext* const context, int regNumber);
    
    int kscpu_numExceptionRegisters(void);
    
    const char* kscpu_exceptionRegisterName(int regNumber);
    
    uint64_t kscpu_exceptionRegisterValue(const struct KSMachineContext* const context, int regNumber);
    
    int kscpu_stackGrowDirection(void);
    
    void kscpu_getState(struct KSMachineContext* destinationContext);
    
    uintptr_t kscpu_normaliseInstructionPointer(uintptr_t ip);
    
#ifdef __cplusplus
}
#endif

#endif /* KSCPU_h */
