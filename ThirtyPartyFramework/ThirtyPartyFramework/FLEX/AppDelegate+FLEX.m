
//
//  AppDelegate+FLEX.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "AppDelegate+FLEX.h"
#if DEBUG
#import <FLEX.h>
#endif

@implementation AppDelegate (FLEX)

- (void)flex_customInitMethod
{
#if DEBUG
    [[FLEXManager sharedManager] showExplorer];
#endif
}

@end
