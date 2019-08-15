//
//  KSID.c
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/8/1.
//  Copyright © 2019 we. All rights reserved.
//

#include <stdio.h>
#include <uuid/uuid.h>


void ksid_generate(char* destinationBuffer37Bytes)
{
    uuid_t uuid;
    uuid_generate(uuid);
    sprintf(destinationBuffer37Bytes,
            "%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
            (unsigned)uuid[0],
            (unsigned)uuid[1],
            (unsigned)uuid[2],
            (unsigned)uuid[3],
            (unsigned)uuid[4],
            (unsigned)uuid[5],
            (unsigned)uuid[6],
            (unsigned)uuid[7],
            (unsigned)uuid[8],
            (unsigned)uuid[9],
            (unsigned)uuid[10],
            (unsigned)uuid[11],
            (unsigned)uuid[12],
            (unsigned)uuid[13],
            (unsigned)uuid[14],
            (unsigned)uuid[15]
            );
    
}
