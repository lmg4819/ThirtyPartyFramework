//
//  KSDebug.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSDebug_h
#define KSDebug_h

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>
    
    /**
     Check if the current process is being traced or not.
     */
    bool ksdebug_isBeingTraced(void);
    
#ifdef __cplusplus
}
#endif

#endif /* KSDebug_h */
