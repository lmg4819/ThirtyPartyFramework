//
//  KSCrashMonitorType.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCrashMonitorType_h
#define KSCrashMonitorType_h

#ifdef __cplusplus
extern "C" {
#endif

/**Various aspects of the system that can be monitored:
 * - Mach-kernal exception
 * - fatal signal
 * - Uncaught C++ exception
 * - Uncaught Objective-C NSException
 * - Deadlock on the main thread
 * - User reported custom exception
 */
 typedef enum {
     KSCrashMonitorTypeMachException        = 0x01,
     
     KSCrashMonitorTypeSignal               = 0x02,
     
     KSCrashMonitorTypeCPPException         = 0x04,
     
     KSCrashMonitorTypeNSException          = 0x08,
     
     KSCrashMonitorTypeMainThreadDeadlock   = 0x10,
     
     KSCrashMonitorTypeUserReported         = 0x20,
     
     KSCrashMonitorTypeSystem               = 0x40,
     
     KSCrashMonitorTypeApplicationState     = 0x80,
     
     KSCrashMonitorTypeZombie               = 0x100,
     
 }KSCrashMonitorType;
    
#define KSCrashMonitorTypeAll                \
(                                            \
     KSCrashMonitorTypeMachException       | \
     KSCrashMonitorTypeSignal              | \
     KSCrashMonitorTypeCPPException        | \
     KSCrashMonitorTypeNSException         | \
     KSCrashMonitorTypeMainThreadDeadlock  | \
     KSCrashMonitorTypeUserReported        | \
     KSCrashMonitorTypeSystem              | \
     KSCrashMonitorTypeApplicationState    | \
     KSCrashMonitorTypeZombie                \
)
   
#define KSCrashMonitorTypeExperimental     \
(                                          \
    KSCrashMonitorTypeMainThreadDeadlock   \
)
    
#define KSCrashMonitorTypeDebuggerUnsafe   \
(                                          \
    KSCrashMonitorTypeMachException      | \
    KSCrashMonitorTypeSignal             | \
    KSCrashMonitorTypeCPPException       | \
    KSCrashMonitorTypeNSException          \
)
    
#define KSCrashMonitorTypeAsyncSafe        \
(                                          \
    KSCrashMonitorTypeMachException      | \
    KSCrashMonitorTypeSignal               \
)
    
#define KSCrashMonitorTypeOptional         \
(                                          \
    KSCrashMonitorTypeZombie               \
)
    
#define KSCrashMonitorTypeAsyncUnsafe (KSCrashMonitorTypeAll & (~KSCrashMonitorTypeAsyncSafe))
    
#define KSCrashMonitorTypeDebuggerSafe (KSCrashMonitorTypeAll & (~KSCrashMonitorTypeDebuggerUnsafe))
    
#define KSCrashMonitorTypeProductionSafe (KSCrashMonitorTypeAll & (~KSCrashMonitorTypeExperimental))
    
#define KSCrashMonitorTypeProductionSafeMinimal (KSCrashMonitorTypeProductionSafe & (~KSCrashMonitorTypeOptional))
    
#define KSCrashMonitorTypeRequired (KSCrashMonitorTypeSystem | KSCrashMonitorTypeApplicationState)
    
#define KSCrashMonitorTypeManual (KSCrashMonitorTypeRequired | KSCrashMonitorTypeUserReported)
    
#define KSCrashMonitorTypeNone 0
    
const char *kscrashmonitortype_name(KSCrashMonitorType monitorType);
    
#ifdef __cplusplus
}
#endif
    


#endif /* KSCrashMonitorType_h */
