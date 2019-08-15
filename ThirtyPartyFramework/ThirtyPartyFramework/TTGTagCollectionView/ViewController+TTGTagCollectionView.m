//
//  ViewController+TTGTagCollectionView.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController+TTGTagCollectionView.h"
#import <TTGTextTagCollectionView.h>

@interface ViewController ()<TTGTextTagCollectionViewDelegate>

@end

@implementation ViewController (TTGTagCollectionView)

- (void)ttg_customInitMethod
{
    TTGTextTagCollectionView *collectionView = [[TTGTextTagCollectionView alloc]init];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    collectionView.horizontalSpacing = 10;
    collectionView.verticalSpacing = 10;
    collectionView.delegate = self;
    collectionView.scrollView.scrollEnabled = NO;
    collectionView.contentInset = UIEdgeInsetsMake(15, 20, 15, 20);
    [self.view addSubview:collectionView];
    TTGTextTagConfig *tagConfig = [TTGTextTagConfig new];
    tagConfig.textFont = [UIFont systemFontOfSize:18.0f];
    
    tagConfig.textColor = [UIColor whiteColor];
    tagConfig.selectedTextColor = [UIColor whiteColor];
    
    //设置背景色
    tagConfig.backgroundColor = [UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1.00];
    tagConfig.selectedBackgroundColor = [UIColor colorWithRed:0.22 green:0.29 blue:0.36 alpha:1.00];
    
    //设置渐变背景色
    tagConfig.enableGradientBackground = NO;
    tagConfig.gradientBackgroundStartColor = [UIColor clearColor];
    tagConfig.gradientBackgroundEndColor = [UIColor clearColor];
    tagConfig.selectedGradientBackgroundStartColor = [UIColor clearColor];
    tagConfig.selectedGradientBackgroundEndColor = [UIColor clearColor];
    tagConfig.gradientBackgroundStartPoint = CGPointMake(0.5, 0.0);
    tagConfig.gradientBackgroundEndPoint = CGPointMake(0.5, 1.0);
    
    //设置圆角效果
    tagConfig.cornerRadius = 4.0f;
    tagConfig.selectedCornerRadius = 4.0f;
    tagConfig.cornerTopLeft = true;
    tagConfig.cornerTopRight = true;
    tagConfig.cornerBottomLeft = true;
    tagConfig.cornerBottomRight = true;
    
    //设置边界
    tagConfig.borderWidth = .0f;
    tagConfig.selectedBorderWidth = .0f;
    tagConfig.borderColor = [UIColor whiteColor];
    tagConfig.selectedBorderColor = [UIColor whiteColor];
    
    //设置阴影
    tagConfig.shadowColor = [UIColor clearColor];
    tagConfig.shadowOffset = CGSizeMake(0, 0);
    tagConfig.shadowRadius = 0;
    tagConfig.shadowOpacity = 0.0;
    
    //设置tagView大小
    tagConfig.extraSpace = CGSizeMake(14, 14);
    tagConfig.maxWidth = 0.0f;
    tagConfig.minWidth = 0.0f;
    
    tagConfig.exactWidth = 0.0f;
    tagConfig.exactHeight = 0.0f;
    
    [collectionView addTags:@[@"TTG", @"Tag", @"collection", @"view",@"TTG", @"Tag", @"collection", @"view",@"TTG", @"Tag", @"collection", @"view",@"TTG", @"Tag", @"collection", @"view"] withConfig:tagConfig];
    
    collectionView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 200);
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    canTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
              currentSelected:(BOOL)currentSelected
                    tagConfig:(TTGTextTagConfig *)config
{
    return YES;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
                    tagConfig:(TTGTextTagConfig *)config
{
    NSLog(@"点击屏幕");
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
            updateContentSize:(CGSize)contentSize
{
    
}


@end
