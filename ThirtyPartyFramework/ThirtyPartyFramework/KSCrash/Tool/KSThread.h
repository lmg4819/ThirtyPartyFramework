//
//  KSThread.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSThread_h
#define KSThread_h

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/types.h>
#include <stdbool.h>
    
    typedef uintptr_t KSThread;
    
    bool ksthread_getThreadName(const KSThread thread, char* const buffer, int bufLength);
    
    bool ksthread_getQueueName(KSThread thread, char* buffer, int bufLength);
    
    KSThread ksthread_self(void);
    
#ifdef __cplusplus
}
#endif

#endif /* KSThread_h */
