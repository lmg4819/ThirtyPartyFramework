//
//  ViewController+FDFullscreenPopGesture.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController+FDFullscreenPopGesture.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@implementation ViewController (FDFullscreenPopGesture)

- (void)fd_customInitMethod
{
    self.fd_prefersNavigationBarHidden = NO;
    self.fd_interactivePopDisabled = NO;
    self.navigationController.fd_viewControllerBasedNavigationBarAppearanceEnabled = YES;
}

@end
