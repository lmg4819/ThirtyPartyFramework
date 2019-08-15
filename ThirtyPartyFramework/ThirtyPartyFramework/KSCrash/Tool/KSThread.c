//
//  KSThread.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/26.
//  Copyright © 2019 we. All rights reserved.
//

#include "KSThread.h"

#include "KSSystemCapabilities.h"
#include "KSMemory.h"

//#define KSLogger_LocalLevel TRACE
#include "KSLogger.h"

#include <dispatch/dispatch.h>
#include <mach/mach.h>
#include <pthread.h>
#include <sys/sysctl.h>

KSThread ksthread_self(void)
{
    thread_t thread_self = mach_thread_self();
    mach_port_deallocate(mach_task_self_, thread_self);
    return (KSThread)thread_self;
}

bool ksthread_getThreadName(const KSThread thread, char* const buffer, int bufLength)
{
    // WARNING: This implementation is no longer async-safe!
    
    const pthread_t pthread = pthread_from_mach_thread_np((thread_t)thread);
    return pthread_getname_np(pthread, buffer, (unsigned)bufLength) == 0;
}

bool ksthread_getQueueName(const KSThread thread, char* const buffer, int bufLength)
{
    // WARNING: This implementation is no longer async-safe!
    
    integer_t infoBuffer[THREAD_IDENTIFIER_INFO_COUNT] = {0};
    thread_info_t info = infoBuffer;
    mach_msg_type_number_t inOutSize = THREAD_IDENTIFIER_INFO_COUNT;
    kern_return_t kr = 0;
    
    kr = thread_info((thread_t)thread, THREAD_IDENTIFIER_INFO, info, &inOutSize);
    if(kr != KERN_SUCCESS)
    {
        KSLOG_TRACE("Error getting thread_info with flavor THREAD_IDENTIFIER_INFO from mach thread : %s", mach_error_string(kr));
        return false;
    }
    
    thread_identifier_info_t idInfo = (thread_identifier_info_t)info;
    if(!ksmem_isMemoryReadable(idInfo, sizeof(*idInfo)))
    {
        KSLOG_DEBUG("Thread %p has an invalid thread identifier info %p", thread, idInfo);
        return false;
    }
    dispatch_queue_t* dispatch_queue_ptr = (dispatch_queue_t*)idInfo->dispatch_qaddr;
    if(!ksmem_isMemoryReadable(dispatch_queue_ptr, sizeof(*dispatch_queue_ptr)))
    {
        KSLOG_DEBUG("Thread %p has an invalid dispatch queue pointer %p", thread, dispatch_queue_ptr);
        return false;
    }
    //thread_handle shouldn't be 0 also, because
    //identifier_info->dispatch_qaddr =  identifier_info->thread_handle + get_dispatchqueue_offset_from_proc(thread->task->bsd_info);
    if(dispatch_queue_ptr == NULL || idInfo->thread_handle == 0 || *dispatch_queue_ptr == NULL)
    {
        KSLOG_TRACE("This thread doesn't have a dispatch queue attached : %p", thread);
        return false;
    }
    
    dispatch_queue_t dispatch_queue = *dispatch_queue_ptr;
    const char* queue_name = dispatch_queue_get_label(dispatch_queue);
    if(queue_name == NULL)
    {
        KSLOG_TRACE("Error while getting dispatch queue name : %p", dispatch_queue);
        return false;
    }
    KSLOG_TRACE("Dispatch queue name: %s", queue_name);
    int length = (int)strlen(queue_name);
    
    // Queue label must be a null terminated string.
    int iLabel;
    for(iLabel = 0; iLabel < length + 1; iLabel++)
    {
        if(queue_name[iLabel] < ' ' || queue_name[iLabel] > '~')
        {
            break;
        }
    }
    if(queue_name[iLabel] != 0)
    {
        // Found a non-null, invalid char.
        KSLOG_TRACE("Queue label contains invalid chars");
        return false;
    }
    bufLength = MIN(length, bufLength - 1);//just strlen, without null-terminator
    strncpy(buffer, queue_name, bufLength);
    buffer[bufLength] = 0;//terminate string
    KSLOG_TRACE("Queue label = %s", buffer);
    return true;
}