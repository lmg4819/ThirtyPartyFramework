//
//  ViewController+VTMagic.m
//  ThirtyPartyFramework
//
//  Created by 罗孟歌 on 2019/8/12.
//  Copyright © 2019 we. All rights reserved.
//

#import "ViewController+VTMagic.h"
#import <VTMagic.h>
#import <objc/runtime.h>

@interface ViewController ()<VTMagicViewDelegate,VTMagicViewDataSource>
@property(nonatomic,strong) VTMagicController *magicController;
@property(nonatomic,strong) UIViewController *leftController;
@property(nonatomic,strong) UIViewController *midController;
@property(nonatomic,strong) UIViewController *rightController;
@end

@implementation ViewController (VTMagic)

- (void)vt_customInitMethod
{
    VTMagicController  *magicController = [[VTMagicController alloc]init];
    magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
    magicController.magicView.navigationColor = [UIColor whiteColor];
    magicController.magicView.sliderColor = RGBCOLOR(169, 37, 37);
    magicController.magicView.switchStyle = VTSwitchStyleStiff;
    magicController.magicView.sliderStyle = VTSliderStyleDefault;
    magicController.magicView.layoutStyle = VTLayoutStyleCenter;
    magicController.magicView.navigationHeight = 40.f;
    magicController.magicView.sliderExtension = 10.f;
    magicController.magicView.needPreloading = YES;
    magicController.magicView.delegate = self;
    magicController.magicView.dataSource = self;
    
    
    UIViewController *leftController = [[UIViewController alloc]init];
    leftController.title = @"left";
    leftController.view.backgroundColor = [UIColor yellowColor];
    self.leftController = leftController;
    
    UIViewController *rightController = [[UIViewController alloc]init];
    rightController.title = @"right";
    rightController.view.backgroundColor = [UIColor redColor];
    self.rightController = rightController;
    
    UIViewController *midController = [[UIViewController alloc]init];
    midController.title = @"mid";
    midController.view.backgroundColor = [UIColor greenColor];
    self.midController = midController;
    
    
    [self addChildViewController:magicController];
    self.magicController = magicController;
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];
    [self.magicController.magicView reloadData];
    [self.magicController switchToPage:1 animated:YES];

    
   
}

- (void)updateViewConstraints {
    UIView *magicView = self.magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[magicView]-34-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}


#pragma mark - VTMagicViewDelegate

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    //    NSLog(@"%s---------%lu",__func__,(unsigned long)pageIndex);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    //    NSLog(@"%s---------%lu",__func__,(unsigned long)pageIndex);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex
{
    NSLog(@"%s-------%lu",__func__,(unsigned long)itemIndex);
}

//- (CGFloat)magicView:(VTMagicView *)magicView itemWidthAtIndex:(NSUInteger)itemIndex
//{
//
//}
//
//- (CGFloat)magicView:(VTMagicView *)magicView sliderWidthAtIndex:(NSUInteger)itemIndex
//{
//
//}

#pragma mark - VTMagicViewDataSource

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return @[@"全部",@"待支付",@"已支付"];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (pageIndex == 0) {
        return  self.leftController;
    }else if (pageIndex == 1){
        return self.midController;
    }
    return self.rightController;
}


#pragma mark - Set Get

- (void)setLeftController:(UIViewController *)leftController
{
    objc_setAssociatedObject(self, @selector(leftController), leftController, OBJC_ASSOCIATION_RETAIN);
}

- (UIViewController *)leftController
{
    return objc_getAssociatedObject(self, @selector(leftController));
}

- (void)setMidController:(UIViewController *)midController
{
    objc_setAssociatedObject(self, @selector(midController), midController, OBJC_ASSOCIATION_RETAIN);
}

- (UIViewController *)midController
{
    return objc_getAssociatedObject(self, @selector(midController));
}

- (void)setRightController:(UIViewController *)rightController
{
    objc_setAssociatedObject(self, @selector(rightController), rightController, OBJC_ASSOCIATION_RETAIN);
}

- (UIViewController *)rightController
{
    return objc_getAssociatedObject(self, @selector(rightController));
}

- (void)setMagicController:(VTMagicController *)magicController
{
    objc_setAssociatedObject(self, @selector(magicController), magicController, OBJC_ASSOCIATION_RETAIN);
}

- (UIViewController<VTMagicProtocol> *)magicController
{
    return objc_getAssociatedObject(self, @selector(magicController));
}

@end
