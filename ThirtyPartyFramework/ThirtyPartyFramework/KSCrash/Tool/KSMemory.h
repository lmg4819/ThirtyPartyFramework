//
//  KSMemory.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSMemory_h
#define KSMemory_h

#ifdef __cplusplus
extern "C" {
#endif


#include <stdbool.h>
    
    bool ksmem_isMemoryReadable(const void* const memory, const int byteCount);
    
    int ksmem_maxReadableBytes(const void* const memory, const int tryByteCount);
    
    bool ksmem_copySafely(const void* restrict const src, void* restrict const dst, int byteCount);
    
    int ksmem_copyMaxPossible(const void* restrict const src, void* restrict const dst, int byteCount);
    
#ifdef __cplusplus
}
#endif
    
#endif /* KSMemory_h */
