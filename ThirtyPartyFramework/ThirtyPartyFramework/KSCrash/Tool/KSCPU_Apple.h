//
//  KSCPU_Apple.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/5.
//  Copyright © 2019 we. All rights reserved.
//

#ifndef KSCPU_Apple_h
#define KSCPU_Apple_h


#ifdef __cplusplus
extern "C" {
#endif
   
    #include <mach/mach_types.h>
    
    bool kscpu_i_fillState(thread_t thread,
                           thread_state_t state,
                           thread_state_flavor_t flavor,
                           mach_msg_type_number_t stateCount);
    
    
#ifdef __cplusplus
}
#endif

    

#endif /* KSCPU_Apple_h */
