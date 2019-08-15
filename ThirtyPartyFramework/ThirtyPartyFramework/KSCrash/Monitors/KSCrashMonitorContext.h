
//
//  KSCrashMonitorContext.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCrashMonitorContext_h
#define KSCrashMonitorContext_h


#ifdef __cplusplus
extern "C" {
#endif
    
#include "KSCrashMonitorType.h"
    
#include <stdbool.h>
#include <stdint.h>

    typedef struct KSCrash_MonitorContext
    {
        /** Unique identifier for this event. */
        const char* eventID;
        /**
         If true, so reported user exception will have the current snapshot.
         */
        bool currentSnapshotUserReported;
        
        /** If true, the environment has crashed hard, and only async-safe
         *  functions should be used.
         */
        bool requiresAsyncSafety;
        
        /** If true, the crash handling system is currently handling a crash.
         * When false, all values below this field are considered invalid.
         */
        bool handlingCrash;
        
        /** If true, a second crash occurred while handling a crash. */
        bool crashedDuringCrashHandling;
        
        /** If true, the registers contain valid information about the crash. */
        bool registersAreValid;
        
        /** True if the crash system has detected a stack overflow. */
        bool isStackOverflow;
        
        /** The machine context that generated the event. */
//        struct KSMachineContext* offendingMachineContext;
        
        /** Address that caused the fault. */
        uintptr_t faultAddress;
        
        /** The type of crash that occurred.
         * This determines which other fields are valid. */
        KSCrashMonitorType crashType;
        
        /** The name of the exception that caused the crash, if any. */
        const char* exceptionName;
        
        /** Short description of why the crash occurred. */
        const char* crashReason;
        
        /** The stack cursor for the trace leading up to the crash.
         *  Note: Actual type is KSStackCursor*
         */
        void* stackCursor;
        
        struct
        {
            /** The mach exception type. */
            int type;
            
            /** The mach exception code. */
            int64_t code;
            
            /** The mach exception subcode. */
            int64_t subcode;
        } mach;
        
        struct
        {
            /** The exception name. */
            const char* name;
            
            /** The exception userInfo. */
            const char* userInfo;
        } NSException;
        
        struct
        {
            /** The exception name. */
            const char* name;
            
        } CPPException;
        
        struct
        {
            /** User context information. */
            const void* userContext;
            int signum;
            int sigcode;
        } signal;
        
        struct
        {
            /** The exception name. */
            const char* name;
            
            /** The language the exception occured in. */
            const char* language;
            
            /** The line of code where the exception occurred. Can be NULL. */
            const char* lineOfCode;
            
            /** The user-supplied JSON encoded stack trace. */
            const char* customStackTrace;
        } userException;
        
        struct
        {
            /** Total active time elapsed since the last crash. */
            double activeDurationSinceLastCrash;
            
            /** Total time backgrounded elapsed since the last crash. */
            double backgroundDurationSinceLastCrash;
            
            /** Number of app launches since the last crash. */
            int launchesSinceLastCrash;
            
            /** Number of sessions (launch, resume from suspend) since last crash. */
            int sessionsSinceLastCrash;
            
            /** Total active time elapsed since launch. */
            double activeDurationSinceLaunch;
            
            /** Total time backgrounded elapsed since launch. */
            double backgroundDurationSinceLaunch;
            
            /** Number of sessions (launch, resume from suspend) since app launch. */
            int sessionsSinceLaunch;
            
            /** If true, the application crashed on the previous launch. */
            bool crashedLastLaunch;
            
            /** If true, the application crashed on this launch. */
            bool crashedThisLaunch;
            
            /** Timestamp for when the app state was last changed (active<->inactive,
             * background<->foreground) */
            double appStateTransitionTime;
            
            /** If true, the application is currently active. */
            bool applicationIsActive;
            
            /** If true, the application is currently in the foreground. */
            bool applicationIsInForeground;
            
        } AppState;
        
        /* Misc system information */
        struct
        {
            const char* systemName;
            const char* systemVersion;
            const char* machine;
            const char* model;
            const char* kernelVersion;
            const char* osVersion;
            bool isJailbroken;
            const char* bootTime;
            const char* appStartTime;
            const char* executablePath;
            const char* executableName;
            const char* bundleID;
            const char* bundleName;
            const char* bundleVersion;
            const char* bundleShortVersion;
            const char* appID;
            const char* cpuArchitecture;
            int cpuType;
            int cpuSubType;
            int binaryCPUType;
            int binaryCPUSubType;
            const char* timezone;
            const char* processName;
            int processID;
            int parentProcessID;
            const char* deviceAppHash;
            const char* buildType;
            uint64_t storageSize;
            uint64_t memorySize;
            uint64_t freeMemory;
            uint64_t usableMemory;
        } System;
        
        struct
        {
            /** Address of the last deallocated exception. */
            uintptr_t address;
            
            /** Name of the last deallocated exception. */
            const char* name;
            
            /** Reason field from the last deallocated exception. */
            const char* reason;
        } ZombieException;
        
        /** Full path to the console log, if any. */
        const char* consoleLogPath;
        
    } KSCrash_MonitorContext;
    

#ifdef __cplusplus
}
#endif
    
#endif /* KSCrashMonitorContext_h */
