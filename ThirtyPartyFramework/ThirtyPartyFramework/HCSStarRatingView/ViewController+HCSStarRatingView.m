//
//  ViewController+HCSStarRatingView.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController+HCSStarRatingView.h"
#import <HCSStarRatingView.h>

@implementation ViewController (HCSStarRatingView)

- (void)hcs_customInitMethod
{
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(110, 380, 100, 34)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 2;
    starRatingView.userInteractionEnabled = YES;
    starRatingView.emptyStarColor = [UIColor whiteColor];
    starRatingView.starBorderColor = [UIColor whiteColor];
    starRatingView.emptyStarImage = [UIImage imageNamed:@"重要会议-常态"];
    starRatingView.filledStarImage = [UIImage imageNamed:@"重要会议-选中"] ;
    [self.view addSubview:starRatingView];
}

@end
