//
//  JSCatonMonitor.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/22.
//  Copyright © 2019 we. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCatonMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;


@end

NS_ASSUME_NONNULL_END
